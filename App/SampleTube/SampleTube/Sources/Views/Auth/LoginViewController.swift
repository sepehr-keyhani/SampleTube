import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private let titleLabel = UILabel()
    private let modeControl = UISegmentedControl(items: ["Sign In", "Sign Up"])
    private let nameField = StyledTextField(type: .name, placeholder: "Full name")
    private let emailField = StyledTextField(type: .email, placeholder: "Email")
    private let passwordField = StyledTextField(type: .password, placeholder: "Password")
    private let primaryButton = PrimaryButton(type: .system)
    private let passwordErrorLabel = UILabel()

    private var isRegisterMode: Bool = false {
        didSet { updateMode() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        navigationItem.title = "Welcome"
        setupViews()
        layoutViews()
    }

    private func setupViews() {
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = Theme.textPrimary
        titleLabel.text = "SampleTube"

        modeControl.selectedSegmentIndex = 0
        modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)

        primaryButton.setTitle("Sign In", for: .normal)
        primaryButton.addTarget(self, action: #selector(primaryTapped), for: .touchUpInside)

        nameField.isHidden = true

        passwordErrorLabel.textColor = .systemRed
        passwordErrorLabel.font = .systemFont(ofSize: 12)
        passwordErrorLabel.numberOfLines = 0
        passwordErrorLabel.isHidden = true

        [titleLabel, modeControl, nameField, emailField, passwordField, passwordErrorLabel, primaryButton].forEach { view.addSubview($0) }
    }

    private func layoutViews() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        modeControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(36)
        }
        nameField.snp.makeConstraints { make in
            make.top.equalTo(modeControl.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        primaryButton.snp.makeConstraints { make in
            make.top.equalTo(passwordErrorLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }

    private func updateMode() {
        nameField.isHidden = !isRegisterMode
        primaryButton.setTitle(isRegisterMode ? "Sign Up" : "Sign In", for: .normal)
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        nameField.placeholder = "Full name"
    }

    @objc private func modeChanged() { isRegisterMode = modeControl.selectedSegmentIndex == 1 }

    @objc private func primaryTapped() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let email = emailField.text ?? ""
                let password = passwordField.text ?? ""
                // Only enforce strong password on Sign Up. For Sign In, do not block.
                if isRegisterMode {
                    guard validatePassword(password) else { return }
                } else {
                    passwordField.setErrorAppearance(false)
                    passwordErrorLabel.isHidden = true
                }
                if isRegisterMode {
                    let name = nameField.text ?? ""
                    let auth = try await APIClient.shared.register(name: name, email: email, password: password)
                    TokenStore.shared.token = auth.token
                } else {
                    let auth = try await APIClient.shared.login(email: email, password: password)
                    TokenStore.shared.token = auth.token
                }
                NotificationCenter.default.post(name: .didLogin, object: nil)
            } catch {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }

    private func validatePassword(_ password: String) -> Bool {
        // At least 8 chars, one uppercase, one lowercase, one digit
        let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let isValid = password.range(of: pattern, options: .regularExpression) != nil
        passwordField.setErrorAppearance(!isValid)
        passwordErrorLabel.isHidden = isValid
        if !isValid {
            passwordErrorLabel.text = "Password must be 8+ chars with upper, lower, and number."
        }
        return isValid
    }
}


