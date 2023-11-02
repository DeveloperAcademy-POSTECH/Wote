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
    @Binding var isWriteViewPresented: Bool
    @Bindable var viewModel: WriteViewModel
    
    var body: some View {
        ZStack {
            Color.background
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        titleView
                        addImageView
                        contentView
                    }
                }
                voteRegisterButton
            }
            .scrollIndicators(.hidden)
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("투표만들기")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
}

extension WriteView {
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerLabel("제목을 입력해주세요. ", "(필수)", essential: true)
                .padding(.bottom, 4)
            HStack(spacing: 6) {
                TextField("",
                          text: $viewModel.title,
                          prompt:
                            Text("예) 아이폰, 맥북 에어 사고싶은데")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.placeholderGray)
                )
                .frame(height: 44)
                .padding(.horizontal, 16)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.darkBlue, lineWidth: 1)
                }
                categoryMenu
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
    
    private var categoryMenu: some View {
        Menu {
            ForEach(PostCategoryType.allCases, id: \.self) { postCategory in
                Button {
                    viewModel.postCategoryType = postCategory
                } label: {
                    Text(postCategory.title)
                }
            }
        } label: {
            HStack(spacing: 18) {
                Text(viewModel.postCategoryType.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(height: 44)
                Button {
                    
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.placeholderGray)
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.disableGray)
            }
        }
        
    }
    
    private var addImageView: some View {
        VStack(alignment: .leading) {
            headerLabel("고민하는 상품의 사진을 등록해 주세요. ", "(선택)", essential: false)
            imageView
            addImageButton
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 165, height: 165)
                    .clipShape(Rectangle())
                    .padding(.bottom, 10)
                removeImageButton
                    .padding(.top, 8)
                    .padding(.trailing, 8)
            }
        }
    }
    
    private var removeImageButton: some View {
        Button {
            selectedPhoto = nil
            selectedImageData = nil
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(.black)
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
    
    private var addLinkButton: some View {
        TextField("",
                  text: $viewModel.externalURL,
                  prompt:
                    Text("링크 주소 입력하기")
            .font(.system(size: 14, weight: .medium)) +
                  Text("(선택)")
            .font(.system(size: 12, weight: .medium)))
        .frame(height: 44)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.gray, lineWidth: 1)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerLabel("고민하는 내용을 작성해 주세요. ", "(선택)", essential: false)
            textView
        }
    }
    
    private var textView: some View {
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
            Text("투표 등록하기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(viewModel.isTitleValid ? Color.blue : Color.gray)
                .cornerRadius(10)
        }
    }
    
    private func headerLabel(_ title: String, _ description: String, essential: Bool) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
        + Text(description)
            .font(.system(size: 12, weight: .semibold))
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
