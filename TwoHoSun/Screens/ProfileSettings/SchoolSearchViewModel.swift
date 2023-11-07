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
    var schools = [SchoolInfoModel]()
    var isFetching = false
    private let baseURL = "http://www.career.go.kr/cnet/openapi/getOpenApi"

    var apiKey: String {
        guard let file = Bundle.main.path(forResource: "Secret", ofType: "plist") else {
            fatalError("can't read file")
        }
        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("can't load resource")
        }
        guard let key = resource["SCHOOL_API_KEY"] as? String else {
            fatalError("SCHOOL_API_KEY error")
        }
        return key
    }

    func setSchoolData(searchWord: String) async throws {
        schools.removeAll()
        isFetching = true

        let highSchoolValues: HighSchoolResponse = try await fetchSchoolData(schoolType: .highSchool, searchWord: searchWord)
        let middleSchoolValues: MiddleSchoolResponse = try await fetchSchoolData(schoolType: .middleSchool, searchWord: searchWord)
        let highSchoolSchools = highSchoolValues.dataSearch.content.map { $0.convertToSchoolInfoModel() }
        let middleSchoolSchools = middleSchoolValues.dataSearch.content.map { $0.convertToSchoolInfoModel() }

        schools.append(contentsOf: highSchoolSchools + middleSchoolSchools)

        isFetching = false
    }

    private func fetchSchoolData<T: Decodable>(schoolType: SchoolDataType, searchWord: String) async throws -> T {
        guard let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            throw URLError(.badURL)
        }

        let url = baseURL +
            """
            ?apiKey=\(apiKey)&svcType=api&svcCode=SCHOOL&contentType=json&gubun=\(schoolType.schoolParam)&searchSchulNm=\(encodedSearchWord)
            """

        print("api_key", apiKey)

        return try await AF.request(url, method: .get)
                        .validate()
                        .serializingDecodable(T.self)
                        .value
    }
}
