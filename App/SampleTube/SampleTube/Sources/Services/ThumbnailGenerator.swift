import Foundation
import AVFoundation
import UIKit

final class ThumbnailGenerator {
    static let shared = ThumbnailGenerator()
    private init() {}

    private let cache = NSCache<NSURL, UIImage>()

    func generateThumbnail(from url: URL, at seconds: Double = 2.0) async -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) { return cached }

        // AVAsset(url:) deprecated, use AVURLAsset(url:)
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: seconds, preferredTimescale: 600)

        // Use async completion-based API recommended by Apple
        return await withCheckedContinuation { continuation in
            generator.generateCGImageAsynchronously(for: time) { cgImage, actualTime, error in
                if let cgImage {
                    let uiImage = UIImage(cgImage: cgImage)
                    self.cache.setObject(uiImage, forKey: url as NSURL)
                    continuation.resume(returning: uiImage)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}


