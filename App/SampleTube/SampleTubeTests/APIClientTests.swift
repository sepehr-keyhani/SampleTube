import XCTest
@testable import SampleTube

final class APIClientTests: XCTestCase {
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient.shared
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testRegisterSuccess() async throws {
        // Mock successful registration
        let name = "Test User"
        let email = "test@example.com"
        let password = "TestPass123"
        
        do {
            let response = try await apiClient.register(name: name, email: email, password: password)
            XCTAssertNotNil(response.token)
            XCTAssertEqual(response.user.email, email)
            XCTAssertEqual(response.user.name, name)
        } catch {
            // In real test environment, you'd mock the network call
            XCTFail("Registration should succeed with valid data")
        }
    }
    
    func testLoginSuccess() async throws {
        let email = "test@example.com"
        let password = "TestPass123"
        
        do {
            let response = try await apiClient.login(email: email, password: password)
            XCTAssertNotNil(response.token)
            XCTAssertEqual(response.user.email, email)
        } catch {
            XCTFail("Login should succeed with valid credentials")
        }
    }
    
    func testListVideosSuccess() async throws {
        do {
            let response = try await apiClient.listVideos(page: 1, limit: 10)
            XCTAssertNotNil(response.data)
            XCTAssertEqual(response.page, 1)
            XCTAssertEqual(response.limit, 10)
            XCTAssertGreaterThanOrEqual(response.total, 0)
        } catch {
            XCTFail("Video list should succeed with valid token")
        }
    }
}
