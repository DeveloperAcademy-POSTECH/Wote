//
//  WriteVIew.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import PhotosUI
import SwiftUI

struct WriteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    @State private var isRegisterButtonDidTap = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isTagTextFieldShowed = false
    @Binding var isWriteViewPresented: Bool
    @Bindable var viewModel: WriteViewModel

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    titleView
                        .padding(.top, 24)
                    addImageView
                        .padding(.top, 32)
                    contentView
                        .padding(.top, 32)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 26)
            }
            voteRegisterButton
                .padding(.bottom, 12)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("소비고민 등록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
    }
}

extension WriteView {

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
        }
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerLabel("제목을 입력해주세요. ", "(필수)")
                .padding(.bottom, 12)
            HStack {
                TextField("",
                          text: $viewModel.title,
                          prompt:
                            Text("한/영 15자 이내(물품)")
                                .font(.system(size: 14)))
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray, lineWidth: 1)
                }
                categoryMenu
            }
            .padding(.bottom, 4)
            if !viewModel.isTitleValid && isRegisterButtonDidTap {
                HStack(spacing: 8) {
                    Image(systemName: "light.beacon.max")
                    Text("제목 입력은 필수입니다.")
                    Spacer()
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
            HStack(spacing: 9) {
                Text(viewModel.postCategoryType.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray)
                    .frame(height: 44)
                    .padding(.leading, 16)
                Button {

                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                        .padding(.trailing, 12 )
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.gray, lineWidth: 1)
            }
        }

    }
    
    private var addImageView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                headerLabel("고민하는 상품 사진을 등록해 주세요. ", "(최대 4개)")
                    .padding(.bottom, 12)
                imageView
                addImageButton
                    .padding(.bottom, 10)
                addLinkButton
            }
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
                Spacer()
                Image(systemName: "plus")
                    .font(.system(size: 16))
                Text("상품 이미지")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.gray)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(.gray, lineWidth: 1)
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
        VStack(alignment: .leading, spacing: 12) {
            headerLabel("내용을 작성해 주세요. ", "(선택)")
            textView
        }
    }

    private var textView: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.content.isEmpty {
                TextEditor(text: $placeholderText)
                    .foregroundStyle(.gray)
            }
            TextEditor(text: $viewModel.content)
                .opacity(self.viewModel.content.isEmpty ? 0.25 : 1)
            contentTextCountView
                .padding(.trailing, 15)
                .padding(.bottom, 14)
        }
        .font(.system(size: 14, weight: .medium))
        .frame(height: 109)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.gray, lineWidth: 1)
        }
    }

    private var contentTextCountView: some View {
        Text("\(viewModel.content.count) ")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.black) +
        Text("/ 100")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.gray)
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

    private func headerLabel(_ title: String, _ description: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold)) +
        Text(description)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.gray)
    }
}

#Preview {
    NavigationStack {
        WriteView(isWriteViewPresented: .constant(true), viewModel: WriteViewModel())
    }
}
