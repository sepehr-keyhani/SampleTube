import UIKit

final class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = Theme.primary
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        layer.cornerRadius = Theme.cornerRadius
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}


