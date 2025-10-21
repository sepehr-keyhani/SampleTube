import XCTest
@testable import SampleTube

final class ModelsTests: XCTestCase {
    
    func testUserDecoding() {
        let jsonData = """
        {
            "_id": "507f1f77bcf86cd799439011",
            "name": "John Doe",
            "email": "john@example.com"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let user = try! decoder.decode(User.self, from: jsonData)
        
        XCTAssertEqual(user.id, "507f1f77bcf86cd799439011")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john@example.com")
    }
    
    func testVideoDecoding() {
        let jsonData = """
        {
            "id": "video123.mp4",
            "title": "Sample Video",
            "url": "/static/videos/video123.mp4"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let video = try! decoder.decode(Video.self, from: jsonData)
        
        XCTAssertEqual(video.id, "video123.mp4")
        XCTAssertEqual(video.title, "Sample Video")
        XCTAssertEqual(video.url, "/static/videos/video123.mp4")
    }
    
    func testVideoAbsoluteURL() {
        let video = Video(id: "test.mp4", title: "Test", url: "/static/videos/test.mp4")
        
        let absoluteURL = video.absoluteURL
        
        XCTAssertNotNil(absoluteURL)
        XCTAssertTrue(absoluteURL!.absoluteString.contains("test.mp4"))
    }
    
    func testAuthResponseDecoding() {
        let jsonData = """
        {
            "user": {
                "_id": "507f1f77bcf86cd799439011",
                "name": "John Doe",
                "email": "john@example.com"
            },
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let authResponse = try! decoder.decode(AuthResponse.self, from: jsonData)
        
        XCTAssertEqual(authResponse.user.name, "John Doe")
        XCTAssertEqual(authResponse.user.email, "john@example.com")
        XCTAssertEqual(authResponse.token, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    }
    
    func testPagedVideosDecoding() {
        let jsonData = """
        {
            "data": [
                {
                    "id": "video1.mp4",
                    "title": "Video 1",
                    "url": "/static/videos/video1.mp4"
                },
                {
                    "id": "video2.mp4",
                    "title": "Video 2",
                    "url": "/static/videos/video2.mp4"
                }
            ],
            "page": 1,
            "limit": 20,
            "total": 2
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let pagedVideos = try! decoder.decode(PagedVideos.self, from: jsonData)
        
        XCTAssertEqual(pagedVideos.data.count, 2)
        XCTAssertEqual(pagedVideos.page, 1)
        XCTAssertEqual(pagedVideos.limit, 20)
        XCTAssertEqual(pagedVideos.total, 2)
        XCTAssertEqual(pagedVideos.data[0].title, "Video 1")
        XCTAssertEqual(pagedVideos.data[1].title, "Video 2")
    }
}
