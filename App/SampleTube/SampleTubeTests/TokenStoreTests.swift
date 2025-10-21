import XCTest
@testable import SampleTube

final class TokenStoreTests: XCTestCase {
    var tokenStore: TokenStore!
    
    override func setUp() {
        super.setUp()
        tokenStore = TokenStore.shared
        // Clear any existing token
        tokenStore.clear()
    }
    
    override func tearDown() {
        tokenStore.clear()
        super.tearDown()
    }
    
    func testTokenStorage() {
        // Test storing token
        let testToken = "test-jwt-token-123"
        tokenStore.token = testToken
        
        XCTAssertEqual(tokenStore.token, testToken)
        XCTAssertTrue(tokenStore.hasToken)
    }
    
    func testTokenRetrieval() {
        let testToken = "another-test-token"
        tokenStore.token = testToken
        
        let retrievedToken = tokenStore.token
        XCTAssertEqual(retrievedToken, testToken)
    }
    
    func testHasTokenProperty() {
        // Initially no token
        XCTAssertFalse(tokenStore.hasToken)
        
        // Set token
        tokenStore.token = "test-token"
        XCTAssertTrue(tokenStore.hasToken)
        
        // Clear token
        tokenStore.clear()
        XCTAssertFalse(tokenStore.hasToken)
    }
    
    func testClearToken() {
        // Set a token
        tokenStore.token = "test-token"
        XCTAssertTrue(tokenStore.hasToken)
        
        // Clear it
        tokenStore.clear()
        XCTAssertNil(tokenStore.token)
        XCTAssertFalse(tokenStore.hasToken)
    }
    
    func testEmptyTokenHandling() {
        // Test empty string
        tokenStore.token = ""
        XCTAssertFalse(tokenStore.hasToken)
        
        // Test nil
        tokenStore.token = nil
        XCTAssertFalse(tokenStore.hasToken)
    }
}
