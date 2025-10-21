import Foundation
import Alamofire

struct APIErrorPayload: Decodable {
    struct Detail: Decodable { let field: String?; let message: String? }
    let error: String?
    let message: String?
    let details: [Detail]?
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        return Session(configuration: configuration)
    }()

    private var apiBaseURL: URL { URL(string: AppConfig.apiBaseURLString)! }

    private func headers(includeAuth: Bool = false) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        if includeAuth, let token = TokenStore.shared.token {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        return headers
    }

    // MARK: - Helpers
    private func requestDecodable<T: Decodable>(
        _ url: URL,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        includeAuth: Bool = false
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers(includeAuth: includeAuth))
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        // Try to decode backend error format { error: string } or validation { details: [{message}] }
                        if let data = response.data,
                           let payload = try? JSONDecoder().decode(APIErrorPayload.self, from: data) {
                            let validationJoined = payload.details?.compactMap { $0.message }.joined(separator: "\n")
                            let msg = validationJoined ?? payload.message ?? payload.error ?? HTTPURLResponse.localizedString(forStatusCode: response.response?.statusCode ?? 0)
                            continuation.resume(throwing: NSError(domain: "api", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: msg]))
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }

    // MARK: - Auth
    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let url = apiBaseURL.appendingPathComponent("auth/register")
        let body: [String: String] = ["name": name, "email": email, "password": password]
        return try await requestDecodable(url, method: .post, parameters: body, encoding: JSONEncoding.default, includeAuth: false)
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let url = apiBaseURL.appendingPathComponent("auth/login")
        let body: [String: String] = ["email": email, "password": password]
        return try await requestDecodable(url, method: .post, parameters: body, encoding: JSONEncoding.default, includeAuth: false)
    }

    // MARK: - Videos
    func listVideos(page: Int = 1, limit: Int = 20) async throws -> PagedVideos {
        let url = apiBaseURL.appendingPathComponent("videos")
        let params: Parameters = ["page": page, "limit": limit]
        return try await requestDecodable(url, method: .get, parameters: params, encoding: URLEncoding.default, includeAuth: true)
    }
}


