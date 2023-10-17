//
//  SchoolSearchViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import Foundation

import Alamofire

@Observable
final class SchoolSearchViewModel {
    var schools = [SchoolModel]()
    private let baseURL = "http://www.career.go.kr/cnet/openapi/getOpenApi"
    private var apiKey: String

    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        self.apiKey = apiKey
    }

    func setSchoolData(searchWord: String) async throws {
        schools.removeAll()

        let highSchoolValues: HighSchoolResponse = try await fetchSchoolData(schoolType: .highSchool, searchWord: searchWord)
        let middleSchoolValues: MiddleSchoolResponse = try await fetchSchoolData(schoolType: .middleSchool, searchWord: searchWord)
        let highSchoolSchools = highSchoolValues.dataSearch.content.map { $0.convertToSchoolModel() }
        let middleSchoolSchools = middleSchoolValues.dataSearch.content.map { $0.convertToSchoolModel() }

        schools.append(contentsOf: highSchoolSchools + middleSchoolSchools)
    }

    private func fetchSchoolData<T: Decodable>(schoolType: SchoolType, searchWord: String) async throws -> T {
        guard let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            throw URLError(.badURL)
        }

        let url = baseURL +
            """
            ?apiKey=\(apiKey)&svcType=api&svcCode=SCHOOL&contentType=json&gubun=\(schoolType.schoolParam)&searchSchulNm=\(encodedSearchWord)
            """

        return try await AF.request(url, method: .get)
                        .validate()
                        .serializingDecodable(T.self)
                        .value
    }
}
