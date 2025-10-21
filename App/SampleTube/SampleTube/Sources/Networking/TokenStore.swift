import Foundation
import KeychainAccess

final class TokenStore {
    static let shared = TokenStore()
    private init() {}

    private let keychain = Keychain(service: "com.sampletube.app")
    private let tokenKey = "auth_token"

    var token: String? {
        get { try? keychain.getString(tokenKey) }
        set {
            if let value = newValue {
                try? keychain.set(value, key: tokenKey)
            } else {
                try? keychain.remove(tokenKey)
            }
        }
    }

    var hasToken: Bool { token?.isEmpty == false }

    func clear() {
        token = nil
        NotificationCenter.default.post(name: .didLogout, object: nil)
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
    static let didLogout = Notification.Name("didLogout")
}


