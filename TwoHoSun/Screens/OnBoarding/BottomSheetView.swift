//
//  BottomSheetView.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI

enum AgreeType: Int {
    case needs, personaldata, marketing
    static func fromRawValue(_ rawValue: Int) -> AgreeType? {
        return AgreeType(rawValue: rawValue)
    }
    var text: String {
        switch self {
        case .needs:
            return "서비스 이용약관, 개인정보 수집 및 이용 동의 (필수)"
        case .personaldata:
            return "개인정보 수집 및 이용 동의 (선택)"
        case .marketing:
            return "마케팅 정보 수신 동의 (선택)"
        }
    }
    var nextPage: some View {
        switch self {
        case .needs:
            return DescriptionView()
        case .personaldata:
            return DescriptionView()
        case .marketing:
            return DescriptionView()
        }
    }
}
struct BottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var checked: [Bool]  = [false, false, false]
    @State private var showAlert = false
    private var allChecked: Bool {
        checked.allSatisfy { $0 }
    }

    var body: some View {
        VStack {
            ZStack {
                Text("약관 동의")
                    .font(Font.system(size: 18, weight: .bold))
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.gray)
                    })
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 18) {
                allCheckBoxView
                    .padding(.bottom, 8)
                    .padding(.top, 50)
                ForEach(0..<3) { index in
                    if let agreeType = AgreeType.fromRawValue(index) {
                        CheckBoxView(checked: $checked[index], agreeType: agreeType)
                    }
                }
            }
            nextButtonView
                .padding(.top, 42)
        }
        
        .padding(.top, 23)
        .padding(.horizontal, 15)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("이용약관에 동의를 해주세요"), dismissButton: .default(Text("확인")))
        }
    }
    
    var nextButtonView: some View {
        Button(action: {
            if checked[0] == false {
                showAlert = true
            } else {
                // 프로필등록으로 이동.
            }
        }, label: {
            Text("동의하고 계속하기")
                .font(Font.system(size: 16))
                .frame(width: 336,height: 54)
                .background(Color.gray)
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(PlainButtonStyle())
    }
    
    var allCheckBoxView: some View {
        HStack {
            Image(systemName: allChecked ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 28,height: 28)
                .foregroundColor(allChecked ? Color(UIColor.black) : Color.gray)
                .onTapGesture {
                    print(allChecked)
                    checked = Array(repeating: !allChecked, count: checked.count)
                }
            Text("전체 동의")
                .font(Font.system(size: 18, weight: .bold)) + Text(" (선택 포함)").font(Font.system(size: 14))
        }
        .padding(.leading, 13)
        .frame(width: 361, height: 58, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .border(.gray, width: 1)
        
    }
    
    struct CheckBoxView: View {
        @Binding var checked: Bool
        var agreeType: AgreeType
        
        var body: some View {
            VStack {
                HStack {
                    Image(systemName: checked ? "checkmark.square.fill" : "square")
                        .foregroundColor(checked ? Color(UIColor.black) : Color.gray)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.checked.toggle()
                        }
                    Text(agreeType.text)
                        .lineLimit(1)
                        .font(Font.system(size: 14))
                    Spacer()
                    NavigationLink(destination: agreeType.nextPage, label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 12, height: 19)
                    })
                    .padding(.trailing, 13)
                }
                .padding(.leading , 10)
                if agreeType.rawValue == 2 {
                    Text("마케팅 정보는 문자, E-mail, Push알림으로 받을 수 있으면 동의 여부는 알림설정에서 확인 가능합니다.")
                        .font(Font.system(size: 10))
                        .padding(.leading, 37)
                        .padding(.trailing, 85)
                    
                }
            }
        }
    }
}

#Preview {
    BottomSheetView()
}
