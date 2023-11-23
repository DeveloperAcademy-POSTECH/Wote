import Combine
import SwiftUI
import Moya

@Observable
class NewApiManager {
    var provider = MoyaProvider<CommonAPIService>()
    var authenticator: Authenticator

    init(authenticator: Authenticator) {
        self.authenticator = authenticator
    }

    func request<T: Decodable>(_ request: CommonAPIService, decodingType: T.Type) -> AnyPublisher<GeneralResponse<T>, NetworkError> {
        return authenticator.authStatePublisher
            .flatMap { authState -> AnyPublisher<GeneralResponse<T>, NetworkError> in
                switch authState {
                case .loggedIn, .unfinishRegister:
                    return self.performRequest(request, decodingType: decodingType)
                default:
                    return Empty<GeneralResponse<T>, NetworkError>()
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func requestLogin(authorization: String) -> AnyPublisher<GeneralResponse<Users>, NetworkError> {
        return provider
            .requestPublisher(.userService(
                .postAuthorCode(authorization: authorization)))
            .tryMap { response in
                try self.handleResponse(response, Users.self)
            }
            .mapError { error in
                if let networkError = error as? ErrorResponse {
                    return NetworkError(divisionCode: networkError.divisionCode)
                }
                return NetworkError(divisionCode: "unknown")
            }
            .eraseToAnyPublisher()
    }

    private func performRequest<T: Decodable>(_ request: CommonAPIService, decodingType: T.Type) -> AnyPublisher<GeneralResponse<T>, NetworkError> {
            return provider
            .requestPublisher(request)
            .tryMap { response in
                try self.handleResponse(response, decodingType)
            }
            .mapError { error in
                if let networkError = error as? ErrorResponse {
                    let errorType = NetworkError(divisionCode: networkError.divisionCode)
                    if errorType == .exipredJWT {
                        self.authenticator.authState = .allexpired
                    } else if errorType == .notCompletedSignup {
                        self.authenticator.authState = .unfinishRegister
                    } else if errorType == .noMember {
                        self.authenticator.authState = .none
                    }
                    return errorType
                } else {
                    print(error)
                    return NetworkError(divisionCode: "unknown")
                }
            }
            .eraseToAnyPublisher()
    }

    private func handleResponse<T: Decodable>(_ response: Response, _ responseType: T.Type) throws -> GeneralResponse<T> {
        guard response.statusCode == 200 else {
            let decodedData = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
            throw decodedData
        }
        let decodedData = try JSONDecoder().decode(GeneralResponse<T>.self, from: response.data)
        return decodedData
    }
}
