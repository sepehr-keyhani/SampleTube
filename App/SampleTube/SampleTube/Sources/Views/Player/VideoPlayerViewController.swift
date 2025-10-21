import UIKit
import AVKit

final class VideoPlayerViewController: AVPlayerViewController {
    private let video: Video

    init(video: Video) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
        title = video.title
        view.backgroundColor = Theme.background
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = video.absoluteURL {
            self.player = AVPlayer(url: url)
            self.player?.play()
        }
    }
}


