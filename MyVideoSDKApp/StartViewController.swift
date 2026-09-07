import UIKit
import ZoomVideoSDK

final class StartViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let roleControl = UISegmentedControl(items: ["Student", "Teacher"])
    private let nameField = UITextField()
    private let classCodeField = UITextField()
    private let roleDescriptionLabel = UILabel()
    private var enterSessionButton: UIButton!

    private let navy = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
    private let indigo = UIColor(red: 0.31, green: 0.27, blue: 0.83, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        updateRoleCopy()
        setupSDK()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupSDK() {
        let initParams = ZoomVideoSDKInitParams()
        initParams.domain = "zoom.us"
        let status = ZoomVideoSDK.shareInstance()?.initialize(initParams)
        if status != .Errors_Success { print("SDK initialization failed: \(String(describing: status))") }
    }

    private func setupAppearance() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 1.0, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        roleControl.selectedSegmentIndex = 0
        roleControl.selectedSegmentTintColor = indigo
        roleControl.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.98, alpha: 1)
        roleControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        roleControl.setTitleTextAttributes([.foregroundColor: navy], for: .normal)
        roleControl.addTarget(self, action: #selector(roleChanged), for: .valueChanged)

        configureTextField(nameField, placeholder: "e.g. Alex Tan", icon: "person")
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .next

        configureTextField(classCodeField, placeholder: "e.g. ZOOM", icon: "number")
        classCodeField.autocapitalizationType = .allCharacters
        classCodeField.returnKeyType = .go

        enterSessionButton = UIButton(type: .system)
        enterSessionButton.configuration = .filled()
        enterSessionButton.configuration?.image = UIImage(systemName: "arrow.right")
        enterSessionButton.configuration?.imagePadding = 10
        enterSessionButton.configuration?.imagePlacement = .trailing
        enterSessionButton.configuration?.baseBackgroundColor = indigo
        enterSessionButton.configuration?.baseForegroundColor = .white
        enterSessionButton.configuration?.background.cornerRadius = 14
        enterSessionButton.configuration?.contentInsets = .init(top: 17, leading: 22, bottom: 17, trailing: 22)
        enterSessionButton.addTarget(self, action: #selector(enterButtonTapped(_:)), for: .touchUpInside)
    }

    private func configureTextField(_ textField: UITextField, placeholder: String, icon: String) {
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.textColor = navy
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 14
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.85, green: 0.86, blue: 0.93, alpha: 1).cgColor
        textField.leftView = makePaddedIcon(icon)
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(red: 0.23, green: 0.27, blue: 0.38, alpha: 1)]
        )
        textField.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        let brandMark = makeSymbol("graduationcap.fill", size: 22, color: .white, background: indigo)
        brandMark.layer.cornerRadius = 14
        let brand = makeLabel("ZOOM", size: 20, weight: .heavy, color: indigo)
        let brandStack = UIStackView(arrangedSubviews: [brandMark, brand])
        brandStack.axis = .horizontal; brandStack.alignment = .center; brandStack.spacing = 10

        let eyebrow = makeLabel("ZOOM VIRTUAL CLASSROOM", size: 12, weight: .bold, color: indigo)
        eyebrow.textAlignment = .center
        let headline = makeLabel("Learning is better\ntogether.", size: 35, weight: .bold, color: navy)
        headline.numberOfLines = 2; headline.textAlignment = .center
        let subtitle = makeLabel("Join your live lesson, share ideas, and collaborate on a shared canvas.", size: 16, weight: .regular, color: .secondaryLabel)
        subtitle.textColor = UIColor(red: 0.25, green: 0.29, blue: 0.40, alpha: 1)
        subtitle.numberOfLines = 0; subtitle.textAlignment = .center
        let headingStack = UIStackView(arrangedSubviews: [eyebrow, headline, subtitle])
        headingStack.axis = .vertical; headingStack.spacing = 12

        let roleTitle = makeLabel("I’m joining as", size: 16, weight: .semibold, color: navy)
        roleDescriptionLabel.font = .systemFont(ofSize: 14)
        roleDescriptionLabel.textColor = .secondaryLabel
        roleDescriptionLabel.numberOfLines = 0
        let nameTitle = makeLabel("Your name", size: 16, weight: .semibold, color: navy)
        let codeTitle = makeLabel("Class code", size: 16, weight: .semibold, color: navy)
        let formStack = UIStackView(arrangedSubviews: [roleTitle, roleControl, roleDescriptionLabel, nameTitle, nameField, codeTitle, classCodeField, enterSessionButton])
        formStack.axis = .vertical; formStack.spacing = 12
        formStack.setCustomSpacing(20, after: roleDescriptionLabel)
        formStack.setCustomSpacing(22, after: classCodeField)

        let lock = UIImageView(image: UIImage(systemName: "lock.fill"))
        lock.tintColor = .secondaryLabel
        lock.preferredSymbolConfiguration = .init(pointSize: 12, weight: .semibold)
        let privacy = makeLabel("Secure video classroom powered by Zoom", size: 12, weight: .regular, color: .secondaryLabel)
        let privacyStack = UIStackView(arrangedSubviews: [lock, privacy])
        privacyStack.axis = .horizontal; privacyStack.alignment = .center; privacyStack.spacing = 6

        let heroGraphic = makeHeroGraphic()
        [brandStack, headingStack, heroGraphic, formStack, privacyStack].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
        NSLayoutConstraint.activate([
            brandMark.widthAnchor.constraint(equalToConstant: 52), brandMark.heightAnchor.constraint(equalToConstant: 52),
            brandStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            brandStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            headingStack.topAnchor.constraint(equalTo: brandStack.bottomAnchor, constant: 34),
            headingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            headingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            heroGraphic.topAnchor.constraint(equalTo: headingStack.bottomAnchor, constant: 28),
            heroGraphic.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroGraphic.widthAnchor.constraint(equalToConstant: 260), heroGraphic.heightAnchor.constraint(equalToConstant: 128),
            formStack.topAnchor.constraint(equalTo: heroGraphic.bottomAnchor, constant: 30),
            formStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            formStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            privacyStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            privacyStack.topAnchor.constraint(equalTo: formStack.bottomAnchor, constant: 22),
            privacyStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28)
        ])
    }

    private func makeHeroGraphic() -> UIView {
        let card = UIView()
        card.backgroundColor = navy
        card.layer.cornerRadius = 24
        card.layer.shadowColor = navy.cgColor; card.layer.shadowOpacity = 0.16
        card.layer.shadowOffset = CGSize(width: 0, height: 12); card.layer.shadowRadius = 18
        let screen = UIView()
        screen.translatesAutoresizingMaskIntoConstraints = false
        screen.backgroundColor = UIColor(red: 0.67, green: 0.83, blue: 1, alpha: 1)
        screen.layer.cornerRadius = 12
        let pen = makeSymbol("pencil.and.scribble", size: 32, color: navy, background: .clear)
        let people = makeLabel("v1.0", size: 12, weight: .bold, color: .white)
        let badge = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        badge.layer.cornerRadius = 12; badge.clipsToBounds = true
        badge.contentView.addSubview(people)
        let caption = makeLabel("LIVE\nCOLLABORATION", size: 8, weight: .bold, color: .white)
        caption.numberOfLines = 2
        caption.lineBreakMode = .byWordWrapping
        caption.adjustsFontSizeToFitWidth = true
        caption.minimumScaleFactor = 0.6
        [screen, pen, badge, caption].forEach { $0.translatesAutoresizingMaskIntoConstraints = false; card.addSubview($0) }
        screen.addSubview(pen)
        people.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screen.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20), screen.centerYAnchor.constraint(equalTo: card.centerYAnchor), screen.widthAnchor.constraint(equalToConstant: 132), screen.heightAnchor.constraint(equalToConstant: 86),
            pen.centerXAnchor.constraint(equalTo: screen.centerXAnchor), pen.centerYAnchor.constraint(equalTo: screen.centerYAnchor),
            badge.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18), badge.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            people.leadingAnchor.constraint(equalTo: badge.contentView.leadingAnchor, constant: 10), people.trailingAnchor.constraint(equalTo: badge.contentView.trailingAnchor, constant: -10), people.topAnchor.constraint(equalTo: badge.contentView.topAnchor, constant: 6), people.bottomAnchor.constraint(equalTo: badge.contentView.bottomAnchor, constant: -6),
            caption.leadingAnchor.constraint(equalTo: screen.trailingAnchor, constant: 17), caption.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12), caption.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -27)
        ])
        return card
    }

    private func makeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text; label.font = .systemFont(ofSize: size, weight: weight); label.textColor = color
        return label
    }

    private func makeSymbol(_ name: String, size: CGFloat, color: UIColor, background: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = background
        let imageView = UIImageView(image: UIImage(systemName: name))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = color; imageView.preferredSymbolConfiguration = .init(pointSize: size, weight: .semibold)
        container.addSubview(imageView)
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor), imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)])
        return container
    }

    private func makePaddedIcon(_ name: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 56))
        let imageView = UIImageView(image: UIImage(systemName: name))
        imageView.tintColor = indigo; imageView.frame = CGRect(x: 17, y: 18, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }

    @objc private func roleChanged() { updateRoleCopy() }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }

        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY - view.safeAreaInsets.bottom)
        scrollView.contentInset.bottom = overlap
        scrollView.verticalScrollIndicatorInsets.bottom = overlap

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curveValue.uintValue << 16)) {
            self.view.layoutIfNeeded()
            if let activeField = [self.nameField, self.classCodeField].first(where: { $0.isFirstResponder }) {
                let fieldFrame = activeField.convert(activeField.bounds, to: self.scrollView)
                self.scrollView.scrollRectToVisible(fieldFrame.insetBy(dx: 0, dy: -24), animated: false)
            }
        }
    }

    private func updateRoleCopy() {
        let isTeacher = roleControl.selectedSegmentIndex == 1
        roleDescriptionLabel.text = isTeacher ? "Host a live lesson and guide your class." : "Join a lesson, ask questions, and collaborate."
        enterSessionButton.configuration?.title = isTeacher ? "Start classroom" : "Enter classroom"
    }

    @IBAction private func enterButtonTapped(_: UIButton) {
        view.endEditing(true)
        let enteredName = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let enteredSessionName = classCodeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !enteredName.isEmpty, !enteredSessionName.isEmpty else {
            let alert = UIAlertController(title: "Complete your details", message: "Enter both your name and class code to join the classroom.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        enterSessionButton.isEnabled = false
        let sessionViewController = SessionViewController()
        sessionViewController.username = enteredName
        sessionViewController.sessionname = enteredSessionName
        sessionViewController.modalPresentationStyle = .fullScreen
        present(sessionViewController, animated: false) { [weak self] in self?.enterSessionButton.isEnabled = true }
    }
}

extension StartViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let fieldFrame = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(fieldFrame.insetBy(dx: 0, dy: -24), animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            classCodeField.becomeFirstResponder()
        } else {
            enterButtonTapped(enterSessionButton)
        }
        return true
    }
}
