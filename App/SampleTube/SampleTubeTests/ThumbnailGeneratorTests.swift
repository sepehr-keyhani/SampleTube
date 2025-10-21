import XCTest
@testable import SampleTube
import AVFoundation

final class ThumbnailGeneratorTests: XCTestCase {
    var thumbnailGenerator: ThumbnailGenerator!
    
    override func setUp() {
        super.setUp()
        thumbnailGenerator = ThumbnailGenerator.shared
    }
    
    func testGenerateThumbnailWithValidURL() async {
        // Create a test video URL (you'd use a real video file in actual tests)
        guard let testVideoURL = Bundle.main.url(forResource: "test-video", withExtension: "mp4") else {
            // Skip test if no test video available
            return
        }
        
        let thumbnail = await thumbnailGenerator.generateThumbnail(from: testVideoURL, at: 2.0)
        
        XCTAssertNotNil(thumbnail)
        XCTAssertTrue(thumbnail is UIImage)
    }
    
    func testGenerateThumbnailWithInvalidURL() async {
        let invalidURL = URL(string: "https://example.com/nonexistent.mp4")!
        
        let thumbnail = await thumbnailGenerator.generateThumbnail(from: invalidURL, at: 2.0)
        
        XCTAssertNil(thumbnail)
    }
    
    func testGenerateThumbnailWithDifferentTimestamps() async {
        guard let testVideoURL = Bundle.main.url(forResource: "test-video", withExtension: "mp4") else {
            return
        }
        
        let thumbnail1 = await thumbnailGenerator.generateThumbnail(from: testVideoURL, at: 1.0)
        let thumbnail2 = await thumbnailGenerator.generateThumbnail(from: testVideoURL, at: 5.0)
        
        // Thumbnails should be different for different timestamps
        if let thumb1 = thumbnail1, let thumb2 = thumbnail2 {
            XCTAssertNotEqual(thumb1, thumb2)
        }
    }
    
    func testThumbnailCaching() async {
        guard let testVideoURL = Bundle.main.url(forResource: "test-video", withExtension: "mp4") else {
            return
        }
        
        // Generate thumbnail twice
        let thumbnail1 = await thumbnailGenerator.generateThumbnail(from: testVideoURL, at: 2.0)
        let thumbnail2 = await thumbnailGenerator.generateThumbnail(from: testVideoURL, at: 2.0)
        
        // Should be the same (cached)
        XCTAssertEqual(thumbnail1, thumbnail2)
    }
}
