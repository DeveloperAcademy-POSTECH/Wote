//
//  MainViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI
import Observation
import Combine

import Alamofire

@Observable
final class MainViewModel {
    var datalist:  [PostModel] = []
    var nextIndex = 0
    var lastPage = false
    var isEmptyList: Bool {
        return datalist.isEmpty
    }

    init() {
        getPosts(30, first: true)
    }

    func getPosts(_ size: Int = 10, first: Bool = false) {
        //        APIManager.shared.requestAPI(type: .getPosts(nextIndex, size)) {  (response: GeneralResponse<PostResponse>) in
        //            switch response.status {
        //            case 200:
        //                guard let data = response.data else {return}
        ////                let postModels = data.map { PostModel(from: $0)}
        ////                self.datalist = first ? postModels : self.datalist + postModels
        ////                print(self.datalist)
        ////                self.lastPage = data.count < 10 ? true : false
        ////                self.nextIndex += 1
        //            case 401:
        //                APIManager.shared.refreshAllTokens()
        //                self.getPosts(size)
        //            default:
        //                print("error서버문제 바구니에게 문의하세요")
        //            }
        //        }
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJwcm92aWRlcklkIjoiMDAwNjA4LmFjNGRlN2M2YTU3MzRmMThiMGIzZDUzNmFmNjQ0YjI4LjE3MjAiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwcm92aWRlcklkIiwidHlwZSI6ImFjY2VzcyIsImlhdCI6MTY5Nzg4ODQ2MywiZXhwIjoxNjk4NDkzMjYzfQ.B-M9KOEvTm25RuZSnPWihkJ8M6N-RWosgIlDlxfZpdo"
        ]
        let url = URLConst.baseURL + "/api/posts"
        let param = [
            "page" : "\(self.nextIndex)",
            "size" : "\(size)"
        ]
        AF.request(url, method: .get, parameters: param, headers: headers)
            .responseDecodable(of: GeneralResponse<[PostResponse]>.self) { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    print(data.data)


                case .failure(let err):
                    print(err)
                }
            }

//            .publishDecodable(type: GeneralResponse<[PostResponse]>.self)
//            .value()
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error)
//                }
//            } receiveValue: { data in
//
//                print(data)
//                //                let postModels = data.map { PostModel(from: $0)}
//            }


    }
}
