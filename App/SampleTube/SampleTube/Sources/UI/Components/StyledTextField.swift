import UIKit

final class StyledTextField: UITextField {
    enum FieldType { case name, email, password }
    private let type: FieldType

    init(type: FieldType, placeholder: String) {
        self.type = type
        super.init(frame: .zero)
        commonInit(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        self.type = .email
        super.init(coder: coder)
        commonInit(placeholder: "")
    }

    private func commonInit(placeholder: String) {
        self.placeholder = placeholder
        borderStyle = .none
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = Theme.cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.quaternaryLabel.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        heightAnchor.constraint(equalToConstant: 48).isActive = true

        keyboardType = type == .email ? .emailAddress : .default
        autocapitalizationType = type == .email ? .none : .words
        isSecureTextEntry = type == .password
    }

    func setErrorAppearance(_ isError: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = (isError ? UIColor.systemRed : UIColor.quaternaryLabel).cgColor
            self.backgroundColor = isError ? UIColor.systemRed.withAlphaComponent(0.06) : UIColor.secondarySystemBackground
        }
    }
}


