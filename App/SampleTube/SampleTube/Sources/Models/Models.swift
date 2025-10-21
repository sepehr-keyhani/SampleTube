import Foundation

struct User: Decodable, Sendable {
    let id: String?
    let name: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name
        case email
    }
}

struct Video: Decodable, Sendable {
    let id: String
    let title: String
    let url: String

    var absoluteURL: URL? {
        guard let base = URL(string: AppConfig.serverBaseURLString) else { return nil }
        if let clipURL = URL(string: url, relativeTo: base) { return clipURL }
        return URL(string: url)
    }
}

struct AuthResponse: Decodable, Sendable {
    let user: User
    let token: String
}

struct PagedVideos: Decodable, Sendable {
    let data: [Video]
    let page: Int
    let limit: Int
    let total: Int
}


