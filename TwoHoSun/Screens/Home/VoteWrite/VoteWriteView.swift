//
//  WriteVIew.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import PhotosUI
import SwiftUI

struct VoteWriteView: View {
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isLinkFocused: Bool
    @FocusState private var isContentFocused: Bool
    @State private var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    @State private var isRegisterButtonDidTap = false
    @State private var croppedImage: UIImage?
    @State private var showPicker: Bool = false
    @State private var isTagTextFieldShowed = false
    @State private var isEditing: Bool = false
    @State private var showCropView: Bool = false
    @State private var isMine: Bool = false
    @State var viewModel: VoteWriteViewModel
    @Binding var tabselection: WoteTabType
    @Environment(AppLoginState.self) private var loginState

    init(viewModel: VoteWriteViewModel, tabselection: Binding<WoteTabType> = Binding.constant(.consider)) {
        self.viewModel = viewModel
        self._tabselection = tabselection
    }

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
                    }
                    .padding(.top, 16)
                }
                voteRegisterButton
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("투표만들기")
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
            .customConfirmDialog(isPresented: $isEditing, isMine: $isMine) { _ in
                Button {
                    showCropView.toggle()
                    isEditing = false
                } label: {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 52)
                Divider()
                    .foregroundStyle(Color.gray300)
                Button {
                    showPicker.toggle()
                    isEditing = false
                } label: {
                    Text("다른 상품사진 선택하기")
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 52)
                Divider()
                    .foregroundStyle(Color.gray300)
                Button {
                    croppedImage = nil
                    isEditing = false
                } label: {
                    Text("삭제하기")
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 52)
            }
        }
        .onChange(of: viewModel.isPostCreated) { _, isPostCreated in
            if isPostCreated {
                NotificationCenter.default.post(name: NSNotification.voteStateUpdated, object: nil)
                loginState.serviceRoot.navigationManager.back()
                tabselection = .consider
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(NSNotification.voteStateUpdated)
        }
    }
}

extension VoteWriteView {
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
            headerLabel("해당 상품의 가격을 알려주세요.", essential: false)
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
            headerLabel("고민하는 상품의 사진을 등록해 주세요. ", essential: false)
            if let croppedImage {
                Image(uiImage: croppedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(.rect(cornerRadius: 16))
                    .onTapGesture {
                        isEditing.toggle()
                    }
                    .onAppear {
                        if let imageData = croppedImage.jpegData(compressionQuality: 1.0) {
                            viewModel.image = imageData
                        }
                    }
            } else {
                Button {
                    showPicker.toggle()
                } label: {
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
                }
            }
        }
        .cropImagePicker(show: $showPicker,
                         showCropView: $showCropView,
                         croppedImage: $croppedImage)
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
            .font(.system(size: 14))
            .focused($isLinkFocused)
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(
                ZStack {
                    if isLinkFocused {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.activeBlack)
                            .shadow(color: Color.strokeBlue.opacity(isLinkFocused ? 0.25 : 0), radius: 4)
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.darkBlue, lineWidth: 1)
                }
            )
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
    
    private var voteRegisterButton: some View {
        Button {
            isRegisterButtonDidTap = true
            if viewModel.isTitleValid {
                viewModel.createPost()
            }
        } label: {
            Text("등록하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.title != "" ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
        .disabled(viewModel.isPostToserver)
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
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}
