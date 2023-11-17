//
//  TypeTestModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import Foundation

struct TypeTestModel {
    let question: String
    let highlight: String
    let choices: [ChoiceModel]
}

struct ChoiceModel {
    let choice: String
    let types: [ConsumerType]
}

let typeTests = [
    TypeTestModel(question: "친구들과 쇼핑몰에 갔을 때나는 주로···",
                  highlight: "쇼핑몰에 갔을 때",
                  choices: [
                    ChoiceModel(choice: "이런게 요즘 유행인가보네, 너무 예쁘다!", types: [.trendsetter]),
                    ChoiceModel(choice: "구찌, 루이, 휠라, 슈프림 보러 가야지", types: [.flexer]),
                    ChoiceModel(choice: "이벤트홀에 가면 새로운 세일 제품들이 업데이트 되었대. 거기부터 가보자!", types: [.budgetKeeper]),
                    ChoiceModel(choice: "이걸 사면 구매 금액의 10%가 숲 조성 기금으로 기부된대. 이걸로 사야겠다!", types: [.ecoWarrior])
                  ]),
    TypeTestModel(question: "내가 추구하는 소비 스타일은?",
                  highlight: "추구하는 소비 스타일",
                  choices: [
                    ChoiceModel(choice: "나는 디자인이 제일 중요해", types: [.beautyLover]),
                    ChoiceModel(choice: "요즘 제일 트렌디하고 다들 좋다는 걸 사", types: [.trendsetter]),
                    ChoiceModel(choice: "내가 써봤던 익숙한 제품이 좋아!", types: [.riskAverse]),
                    ChoiceModel(choice: "최대한 싸고 가성비 좋은 거!", types: [.budgetKeeper])
                  ]),
    TypeTestModel(question: "친구 생일 선물을 사야 할 때 나는?",
                  highlight: "친구 생일 선물",
                  choices: [
                    ChoiceModel(choice: "친구가 사달라는 거 뭐든지!! 다 사줘", types: [.flexer]),
                    ChoiceModel(choice: "친구가 신발이 갖고 싶다고 했는데, 프라이탁 제품을 선물로 줘 볼까?", types: [.ecoWarrior]),
                    ChoiceModel(choice: "인스타에서 요즘 유행하는 걸로 사줘야겠다!", types: [.trendsetter]),
                    ChoiceModel(choice: "내가 써봤을 때 좋았던 경험이 있던걸로 사야겠다!", types: [.riskAverse])
                  ]),
    TypeTestModel(question: "나의 쇼핑 습관을 한마디로 표현하면?",
                  highlight: "쇼핑 습관을 한마디",
                  choices: [
                    ChoiceModel(choice: "일단 사고 보는 편이야", types: [.impulseBuyer]),
                    ChoiceModel(choice: "최신 유행을 따라가야지!", types: [.trendsetter]),
                    ChoiceModel(choice: "가격 대비 품질이 최고!", types: [.budgetKeeper]),
                    ChoiceModel(choice: "새로운 것에 도전하는 걸 좋아해!", types: [.adventurer])
                  ]),
    TypeTestModel(question: "나만의 스타일을 유지하기 위해 나는?",
                  highlight: "나만의 스타일을 유지",
                  choices: [
                    ChoiceModel(choice: "이쁘고 멋져야 스타일이 살지!", types: [.beautyLover]),
                    ChoiceModel(choice: "여러가지 다양한 스타일을 시도해 봐", types: [.adventurer]),
                    ChoiceModel(choice: "명품을 입어야 스타일이 살지", types: [.flexer]),
                    ChoiceModel(choice: "업사이클링만의 유니크한 스타일이 있지", types: [.ecoWarrior])
                  ]),
    TypeTestModel(question: "나의 쇼핑 모토는?",
                  highlight: "쇼핑 모토",
                  choices: [
                    ChoiceModel(choice: "신뢰할 수 있는 브랜드만 골라!", types: [.riskAverse]),
                    ChoiceModel(choice: "가격이 저렴하면 그게 최고야!", types: [.budgetKeeper]),
                    ChoiceModel(choice: "신상이 제일 좋은 거야!", types: [.adventurer]),
                    ChoiceModel(choice: "내꺼다 싶으면 사야지!", types: [.impulseBuyer])
                  ]),
    TypeTestModel(question: "친구가 나에게 쇼핑 조언을 구한다면?",
                  highlight: "쇼핑 조언을 구한다",
                  choices: [
                    ChoiceModel(choice: "이 브랜드 진짜 좋아, 비싸지만 한 번 사봐!", types: [.flexer, .riskAverse]),
                    ChoiceModel(choice: "제품을 고를 때는 디자인이 예쁜 걸 사야 해", types: [.beautyLover]),
                    ChoiceModel(choice: "일단 직접 가서 사고 싶은거 사!", types: [.impulseBuyer]),
                    ChoiceModel(choice: "다양한 제품을 둘러보고 네 스타일에 맞는 걸 찾아보는건 어때?", types: [.adventurer])
                  ])
]
