//
//  WriteVIew.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import PhotosUI
import SwiftUI

struct WriteView: View {
    @State private var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    @State private var isRegisterButtonDidTap = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isTagTextFieldShowed = false
    @State private var isEditing: Bool = false
    @Binding var isWriteViewPresented: Bool
    @Bindable var viewModel: WriteViewModel
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(spacing: 48) {
                        titleView
                        priceView
                        imageView
                        linkView
                        contentView
                        Spacer()
                            .frame(height: 60)
                    }
                    .padding(.top, 16)
                }
                voteRegisterButton
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
            .ignoresSafeArea(.keyboard)
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("투표만들기")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
}

extension WriteView {
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
                .foregroundStyle(.white)
                .frame(height: 44)
                .padding(.horizontal, 16)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(!viewModel.isTitleValid && isRegisterButtonDidTap ? .red : Color.darkBlue, lineWidth: 1)
                }
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
            headerLabel("해당 상품의 가격을 알려주세요.", essential: false)
            HStack {
                TextField("",
                          text: $viewModel.price,
                          prompt: Text("예) 200,000")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.placeholderGray)
                )
                .font(.system(size: 14))
                .keyboardType(.numberPad)
                Text("원")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
        }
    }
    
    private var imageView: some View {
        VStack(alignment: .leading) {
            headerLabel("고민하는 상품의 사진을 등록해 주세요. ", essential: false)
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
    
    private var linkView: some View {
        VStack(alignment: .leading) {
            headerLabel("해당 상품의 링크를 등록해 주세요. ", essential: false)
            TextField("",
                      text: $viewModel.externalURL,
                      prompt: Text("예) 상품 페이지 주소 붙여넣기")
                .font(.system(size: 14))
                .foregroundStyle(Color.placeholderGray)
            )
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                .padding(.bottom, 20)
            contentTextCountView
        }
        .font(.system(size: 14, weight: .medium))
        .frame(height: 110)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.darkBlue, lineWidth: 1)
        }
        .onSubmit {
            dismissKeyboard()
        }
    }
    
    private var contentTextCountView: some View {
        Text("\(viewModel.content.count) ")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.descriptionGray)
        + Text("/ 150")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
    }
    
    private var voteRegisterButton: some View {
        Button {
            isRegisterButtonDidTap = true
            if viewModel.isTitleValid {
                viewModel.createPost()
                isWriteViewPresented = false
            }
            print("complete button did tap!")
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
        WriteView(isWriteViewPresented: .constant(true), viewModel: WriteViewModel())
    }
}
