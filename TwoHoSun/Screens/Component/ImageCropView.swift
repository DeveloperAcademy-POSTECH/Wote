//
//  ImageCropView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import SwiftUI
import PhotosUI

struct CustomImagePicker<Content: View>: View {
    var content: Content
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    @Binding var showCropView: Bool
    init(show: Binding<Bool>, showCropView: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self._showCropView = showCropView
    }
    
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) {
                if let photosItem {
                    Task {
                        if let imageData = try? await photosItem.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            await MainActor.run {
                                selectedImage = image
                            }
                        }
                    }
                }
                showCropView.toggle()
            }
            .fullScreenCover(isPresented: $showCropView, content: {
                CropView(image: selectedImage) { croppedImage, _ in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            })
    }
}

struct CropView: View {
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @State private var rotation: Double = 0
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                imageView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    Spacer()
                    imageToolbar
                }
            }
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("이미지 수정하기")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let renderer = ImageRenderer(content: imageView())
                        renderer.proposedSize = .init(CGSize(width: 358, height: 240))
                        if let image = renderer.uiImage {
                            onCrop(image, true)
                        } else {
                            onCrop(nil, false)
                        }
                        dismiss()
                    } label: {
                        Text("완료")
                            .foregroundStyle(Color.lightBlue)
                    }
                }
            }
        }
    }
}

extension CropView {
    @ViewBuilder
    func imageView() -> some View {
        GeometryReader { geo in
            let size = geo.size
            if let image {
                imageContent(for: image, size: size)
            }
        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .offset(offset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnifyGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let updatedScale = value.magnification + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                })
                .onEnded({ _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(CGSize(width: 358, height: 240))
        .clipShape(.rect(cornerRadius: 0))
    }
    
    private func imageContent(for image: UIImage, size: CGSize) -> some View {
        Image(uiImage: image)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .overlay {
                   GeometryReader { proxy in
                       let rect = proxy.frame(in: .named("CROPVIEW"))
                       Color.clear
                           .onChange(of: isInteracting) {
                               withAnimation(.easeInOut(duration: 0.3)) {
                                   if rect.minX > 0 {
                                       offset.width = (offset.width - rect.minX)
                                   }
                                   if rect.minY > 0 {
                                       offset.height = (offset.height - rect.minY)
                                   }
                                   if rect.maxX < size.width {
                                       offset.width = (rect.minX - offset.width)
                                   }
                                   if rect.maxY < size.height {
                                       offset.height = (rect.minY - offset.height)
                                   }
                               }
                               lastStoredOffset = offset
                           }
                   }
               }
               .frame(size)
    }
    private var imageToolbar: some View {
        ZStack(alignment: .top) {
            Color.background
            HStack(spacing: 32) {
                toolbarButton("rotate.left.fill") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        rotation -= 90
                    }
                }
                toolbarButton("arrow.clockwise") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scale = 1
                        offset = .zero
                    }
                }
                toolbarButton("rotate.right.fill") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        rotation += 90
                    }
                }
            }
            .padding(.top, 8)
        }
        .frame(height: 80)
    }
    
    private func toolbarButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: label)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
        }
    }
}

extension View {
    @ViewBuilder
    func cropImagePicker(show: Binding<Bool>, showCropView: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(show: show, showCropView: showCropView, croppedImage: croppedImage) {
            self
        }
    }
    
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
}

#Preview {
    NavigationStack {
//        ImageCropView()
        CropView(image: UIImage(named: "sample")) { _, _ in
            
        }
    }
}
