import UIKit
import SnapKit

final class VideoListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var collectionView: UICollectionView!
    private var videos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        navigationItem.title = "Videos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        setupCollectionView()
        observeAuth()
        loadVideos()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cell")

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func observeAuth() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogin), name: .didLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: .didLogout, object: nil)
    }

    @objc private func handleLogin() { loadVideos() }
    @objc private func handleLogout() { videos = []; collectionView.reloadData() }

    @objc private func logoutTapped() {
        TokenStore.shared.clear()
        navigationController?.setViewControllers([LoginViewController()], animated: true)
    }

    private func loadVideos() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await APIClient.shared.listVideos(page: 1, limit: 30)
                self.videos = page.data
                self.collectionView.reloadData()
            } catch {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    // MARK: - Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { videos.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
        cell.configure(with: videos[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.item]
        let vc = VideoPlayerViewController(video: video)
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12 - 12 - 8) / 2
        return CGSize(width: width, height: width * 0.75 + 48)
    }
}

final class VideoCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = Theme.cornerRadius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.separator.cgColor
        contentView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.numberOfLines = 2
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with video: Video) {
        titleLabel.text = video.title
        imageView.image = UIImage(systemName: "video")
        if let url = video.absoluteURL {
            Task { [weak self] in
                let thumb = await ThumbnailGenerator.shared.generateThumbnail(from: url)
                await MainActor.run { self?.imageView.image = thumb ?? UIImage(systemName: "video") }
            }
        }
    }
}


