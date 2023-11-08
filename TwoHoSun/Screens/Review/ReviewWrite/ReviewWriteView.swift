//
//  ReviewWriteView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import PhotosUI
import SwiftUI

struct ReviewWriteView: View {
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isContentFocused: Bool
    @State private var isRegisterButtonDidTap = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isEditing: Bool = false
    @State private var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    @Bindable private var viewModel: ReviewWriteViewModel = ReviewWriteViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(spacing: 48) {
                        VStack(spacing: 12) {
                            VoteCardView(cardType: .simple, searchFilterType: .end, isPurchased: true)
                            buySelection
                        }
                        titleView
                        priceView
                        if viewModel.isBuy {
                            imageView
                        }
                        contentView
                        Spacer()
                    }
                    .padding(.top, 16)
                }
                reviewRegisterButton
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("후기 작성하기")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .customConfirmDialog(isPresented: $isEditing) {
                Button("수정하기") {
                    isEditing = false
                }
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                Divider()
                    .foregroundStyle(Color.gray300)
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Text("다른 상품사진 선택하기")
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .onChange(of: selectedPhoto) { _, newValue in
                        PHPhotoLibrary.requestAuthorization { status in
                            guard status == .authorized else { return }
                            
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                    isEditing = false
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                Divider()
                    .foregroundStyle(Color.gray300)
                Button("삭제하기") {
                    selectedPhoto = nil
                    selectedImageData = nil
                    isEditing = false
                }
                .frame(maxWidth: .infinity)
                .frame(height: 42)
            }
        }
    }
}

extension ReviewWriteView {
    
    private var buySelection: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkblue, lineWidth: 1)
                HStack(spacing: 0) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isBuy = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(viewModel.isBuy ? Color.lightBlue : .clear)
                            Text("샀다")
                                .font(.system(size: 16, weight: viewModel.isBuy ? .bold : .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 44)
                    .contentShape(Rectangle())
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isBuy = false
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(viewModel.isBuy ? .clear : Color.lightBlue)
                            Text("안샀다")
                                .font(.system(size: 16, weight: viewModel.isBuy ? .bold : .medium))
                                .foregroundStyle(.white)
                        }
                    }
                }
            
        }
        .frame(height: 44)
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerLabel("제목을 입력해주세요. ", essential: true)
                .padding(.bottom, 4)
            HStack(spacing: 6) {
                TextField("",
                          text: $viewModel.title,
                          prompt:
                            Text("예) 아이폰, 맥북 에어 사고싶은데")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.placeholderGray)
                )
                .font(.system(size: 14))
                .focused($isTitleFocused)
                .foregroundStyle(.white)
                .frame(height: 44)
                .padding(.horizontal, 16)
                .background(
                    ZStack {
                        if isTitleFocused {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.activeBlack)
                                .shadow(color: Color.strokeBlue.opacity(isTitleFocused ? 0.25 : 0), radius: 4)
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(!viewModel.isTitleValid && isRegisterButtonDidTap ? .red : Color.darkBlue, lineWidth: 1)
                    }
                )
            }
            if !viewModel.isTitleValid && isRegisterButtonDidTap {
                HStack(spacing: 8) {
                    Image(systemName: "light.beacon.max")
                    Text("제목을 입력해주세요.")
                }
                .font(.system(size: 12))
                .foregroundStyle(.red)
            }
        }
    }
    
    private var priceView: some View {
        VStack(alignment: .leading) {
            headerLabel("결제한 상품의 가격을 알려주세요.", essential: false)
            HStack {
                TextField("",
                          text: $viewModel.price,
                          prompt: Text("예) 200,000")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.placeholderGray)
                )
                .focused($isPriceFocused)
                .font(.system(size: 14))
                .keyboardType(.numberPad)
                Text("원")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(
                ZStack {
                    if isPriceFocused {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.activeBlack)
                            .shadow(color: Color.strokeBlue.opacity(isPriceFocused ? 0.25 : 0), radius: 4)
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.darkBlue, lineWidth: 1)
                }
            )
        }
    }
    
    private var imageView: some View {
        VStack(alignment: .leading) {
            headerLabel("구매한 상품의 사진을 등록해 주세요. ", essential: true)
            if selectedImageData != nil {
                selectedImageView
                    .onTapGesture {
                        isEditing.toggle()
                    }
            } else {
                addImageButton
            }
        }
    }
    
    @ViewBuilder
    private var selectedImageView: some View {
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .frame(height: 218)
                .clipShape(.rect(cornerRadius: 16))
        }
    }
    
    private var addImageButton: some View {
        PhotosPicker(selection: $selectedPhoto,
                     matching: .images,
                     photoLibrary: .shared()) {
            HStack(spacing: 7) {
                Image(systemName: "plus")
                    .font(.system(size: 16))
                Text("상품 이미지")
                    .font(.system(size: 14, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .foregroundStyle(Color.lightBlue)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
            .onChange(of: selectedPhoto) { _, newValue in
                PHPhotoLibrary.requestAuthorization { status in
                    guard status == .authorized else { return }
                    
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            headerLabel("고민하는 내용을 작성해 주세요. ", essential: false)
            textEditorView
        }
    }
    
    private var textEditorView: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.content.isEmpty {
                TextEditor(text: $placeholderText)
                    .foregroundStyle(Color.placeholderGray)
                    .scrollContentBackground(.hidden)
            }
            TextEditor(text: $viewModel.content)
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 24)
                .focused($isContentFocused)
            contentTextCountView
                .padding(.bottom, 4)
                .padding(.trailing, 4)
        }
        .font(.system(size: 14, weight: .medium))
        .frame(height: 110)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            ZStack {
                if isContentFocused {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.activeBlack)
                        .shadow(color: Color.strokeBlue.opacity(isContentFocused ? 0.25 : 0), radius: 4)
                }
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
        )
        .onSubmit {
            dismissKeyboard()
        }
    }
    
    private var contentTextCountView: some View {
        Text("\(viewModel.content.count) ")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.subGray1)
        + Text("/ 150")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
    }
    
    private var reviewRegisterButton: some View {
        Button {
                        isRegisterButtonDidTap = true
            //            if viewModel.isTitleValid {
            //                viewModel.createPost()
            //                isWriteViewPresented = false
            //            }
        } label: {
            Text("등록하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.title != "" ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
    }
    
    private func headerLabel(_ title: String, essential: Bool) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
        + Text(essential ? "(필수)" : "(선택)")
            .font(.system(size: 12, weight: essential ? .semibold : .medium))
            .foregroundStyle(essential ? .red : Color.subGray3)
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationStack {
        ReviewWriteView()
    }
}
