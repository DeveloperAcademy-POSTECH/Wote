//
//  WriteVIew.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct WriteView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                titleView
                    .padding(.top, 24)
                tagView
                    .padding(.top, 32)
                addImageView
                    .padding(.top, 30)
                voteDeadlineView
                    .padding(.top, 32)
                contentView
                    .padding(.top, 32)
            }
            .padding(.horizontal, 26)
        }
        .navigationTitle("소비고민 등록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
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
        VStack(alignment: .leading, spacing: 12) {
            Text("제목을 입력해주세요. ")
                .font(.system(size: 16, weight: .semibold)) +
            Text("(필수)")
                .font(.system(size: 12, weight: .semibold))
            HStack {
                roundedTextField(
                    Text("한/영 15자 이내(물품)")
                        .font(.system(size: 14))
                )
                titleCategory
            }
        }
    }

    private var titleCategory: some View {
        HStack(spacing: 9) {
            Text("살까 말까")
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

    private var tagView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("태그를 선택해 주세요. ")
                .font(.system(size: 16, weight: .semibold)) +
            Text("(최대 3개 태그 선택 가능)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray)
            HStack {
                addTagButton
                Spacer()
            }
        }
    }

    private var addTagButton: some View {
        Button {
            print("add tag button did tap!")
        } label: {
            ZStack {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.gray)
                Image(systemName: "plus")
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
            }
        }
    }

    private var addImageView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("고민하는 상품 사진을 등록해 주세요. ")
                .font(.system(size: 16, weight: .semibold)) +
            Text("(최대 4개)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray)
            addImageButton
                .padding(.top, 12)
                .padding(.bottom, 10)
            addLinkButton
        }
    }

    private var addImageButton: some View {
        Button {
            print("add image button did tap!")
        } label: {
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
        }
    }

    private var addLinkButton: some View {
        roundedTextField(
            Text("링크 주소 입력하기 ")
                .font(.system(size: 14, weight: .medium)) +
            Text("(선택)")
                .font(.system(size: 12, weight: .medium))
        )
    }

    private var voteDeadlineView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("투표 종료일을 선택해 주세요.")
                .font(.system(size: 16, weight: .semibold))
            Rectangle()
                .frame(height: 3)
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerLabel("내용을 작성해 주세요. ", "(선택)")
        }
    }

    private func headerLabel(_ title: String, _ description: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold)) +
        Text(description)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.gray)
    }

    private func roundedTextField(_ prompt: Text) -> some View {
        HStack(spacing: 0) {
            prompt
                .foregroundStyle(.gray)
                .frame(height: 46)
                .padding(.leading, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.gray, lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        WriteView()
    }
}
