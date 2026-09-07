import UIKit
import PDFKit
import ZoomVideoSDK

extension SessionViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
        setupTabBar()
        setupAnnotationPanel()
        setupParticipantsPanel()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        // Setup scroll view
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true

        // Setup video stack view
        videoStackView.axis = .vertical
        videoStackView.spacing = 8
        videoStackView.alignment = .fill
        videoStackView.distribution = .fillEqually

        for item in [sessionHeader, loadingLabel, scrollView, tabBar] {
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }

        scrollView.addSubview(videoStackView)
        videoStackView.translatesAutoresizingMaskIntoConstraints = false

        let brand = UILabel()
        brand.text = "ZOOM  CLASSROOM"
        brand.font = .systemFont(ofSize: 14, weight: .heavy)
        brand.textColor = .white
        let live = UILabel()
        live.text = "●  LIVE SESSION"
        live.font = .systemFont(ofSize: 11, weight: .bold)
        live.textColor = UIColor(red: 0.62, green: 0.78, blue: 1, alpha: 1)
        let headerStack = UIStackView(arrangedSubviews: [brand, live])
        headerStack.axis = .vertical
        headerStack.spacing = 3
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        sessionHeader.backgroundColor = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        sessionHeader.addSubview(headerStack)
        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: sessionHeader.leadingAnchor, constant: 20),
            headerStack.centerYAnchor.constraint(equalTo: sessionHeader.centerYAnchor)
        ])
        
        sharerView.isHidden = true
        shareBtnStackView.isHidden = true
        shareBtnStackView.spacing = 20
        sharedPDFView.isHidden = true
        view.addSubview(sharerView)
        sharerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup share related view
        sharerView.backgroundColor = .black
        view.addSubview(sharedPDFView)
        sharedPDFView.autoScales = true
        sharedPDFView.translatesAutoresizingMaskIntoConstraints = false
        
        shareBtnStackView.backgroundColor = UIColor(red: 0.12, green: 0.18, blue: 0.33, alpha: 0.96)
        shareBtnStackView.axis = .vertical
        shareBtnStackView.spacing = 12
        shareBtnStackView.layoutMargins = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        shareBtnStackView.isLayoutMarginsRelativeArrangement = true
        shareBtnStackView.layer.cornerRadius = 20
        shareBtnStackView.clipsToBounds = true
        
        shareDrawBtn.setImage(UIImage(systemName: "pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)), for: .normal)
        shareDrawBtn.tintColor = .white
        shareDrawBtn.backgroundColor = UIColor(red: 0.31, green: 0.27, blue: 0.83, alpha: 1)
        shareDrawBtn.layer.cornerRadius = 16
        shareDrawBtn.widthAnchor.constraint(equalToConstant: 56).isActive = true
        shareDrawBtn.heightAnchor.constraint(equalToConstant: 56).isActive = true
        shareDrawBtn.addTarget(self, action: #selector(toggleDraw), for: .touchUpInside)
        shareBtnStackView.addArrangedSubview(shareDrawBtn)
        
        view.addSubview(shareBtnStackView)
        shareBtnStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup local view during share
        localViewDuringShare.isHidden = true
        view.addSubview(localViewDuringShare)
        localViewDuringShare.translatesAutoresizingMaskIntoConstraints = false
        localViewDuringShare.layer.cornerRadius = 15
        localViewDuringShare.clipsToBounds = true

        loadingLabel.text = "Joining your classroom…"
        loadingLabel.textColor = .white
        loadingLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    }

    private func setupConstraints() {
        // Main container constraints
        NSLayoutConstraint.activate([
            sessionHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sessionHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sessionHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sessionHeader.heightAnchor.constraint(equalToConstant: 58),
            scrollView.topAnchor.constraint(equalTo: sessionHeader.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),

            videoStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            videoStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            videoStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            videoStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            videoStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
            
            // sharerView is for viewer
            sharerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            sharerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),
            sharerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            sharerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            // sharedPDFView is for sharer
            sharedPDFView.topAnchor.constraint(equalTo: sessionHeader.bottomAnchor),
            sharedPDFView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sharedPDFView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sharedPDFView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            shareBtnStackView.centerYAnchor.constraint(equalTo: sharerView.centerYAnchor),
            shareBtnStackView.leadingAnchor.constraint(equalTo: sharerView.leadingAnchor, constant: 8),
            shareBtnStackView.widthAnchor.constraint(equalToConstant: 68),
            
            // localViewDuringShare is for local user during screen sharing
            localViewDuringShare.topAnchor.constraint(equalTo: sessionHeader.bottomAnchor, constant: 8),
            localViewDuringShare.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            localViewDuringShare.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
            localViewDuringShare.heightAnchor.constraint(equalTo: localViewDuringShare.widthAnchor, multiplier: 1.0),

            tabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // Loading label
        loadingLabel.center(in: view, yOffset: -30)
    }

    private func setupTabBar() {
        tabBar.delegate = self
        tabBar.isHidden = true
        tabBar.backgroundColor = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        tabBar.barTintColor = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        tabBar.tintColor = UIColor(red: 0.55, green: 0.52, blue: 1, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 0.70, green: 0.75, blue: 0.86, alpha: 1)
        let leaveSessionBarItem = UITabBarItem(title: "Leave Session", image: UIImage(systemName: "phone.down"), tag: ControlOption.leaveSession.rawValue)
        tabBar.items = [toggleVideoBarItem, toggleAudioBarItem, toggleShareBarItem, participantsBarItem, leaveSessionBarItem]
    }

    private func setupParticipantsPanel() {
        participantsPanel.translatesAutoresizingMaskIntoConstraints = false
        participantsPanel.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 1.0, alpha: 1)
        participantsPanel.layer.cornerRadius = 26
        participantsPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        participantsPanel.layer.shadowColor = UIColor.black.cgColor
        participantsPanel.layer.shadowOpacity = 0.24
        participantsPanel.layer.shadowRadius = 18
        participantsPanel.layer.shadowOffset = CGSize(width: 0, height: -6)
        participantsPanel.isHidden = true
        view.addSubview(participantsPanel)

        let title = UILabel()
        title.text = "Class participants"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textColor = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        participantCountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        participantCountLabel.textColor = UIColor(red: 0.31, green: 0.27, blue: 0.83, alpha: 1)

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        closeButton.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.97, alpha: 1)
        closeButton.layer.cornerRadius = 17
        closeButton.addTarget(self, action: #selector(closeParticipantsPanel), for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [title, participantCountLabel])
        textStack.axis = .vertical; textStack.spacing = 2
        let header = UIStackView(arrangedSubviews: [textStack, closeButton])
        header.alignment = .center
        header.translatesAutoresizingMaskIntoConstraints = false

        participantsTableView.translatesAutoresizingMaskIntoConstraints = false
        participantsTableView.backgroundColor = .clear
        participantsTableView.separatorStyle = .none
        participantsTableView.dataSource = self
        participantsTableView.delegate = self
        participantsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ParticipantCell")
        participantsPanel.addSubview(header)
        participantsPanel.addSubview(participantsTableView)
        NSLayoutConstraint.activate([
            participantsPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            participantsPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            participantsPanel.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            participantsPanel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.52),
            header.topAnchor.constraint(equalTo: participantsPanel.topAnchor, constant: 18),
            header.leadingAnchor.constraint(equalTo: participantsPanel.leadingAnchor, constant: 22),
            header.trailingAnchor.constraint(equalTo: participantsPanel.trailingAnchor, constant: -22),
            closeButton.widthAnchor.constraint(equalToConstant: 34),
            closeButton.heightAnchor.constraint(equalToConstant: 34),
            participantsTableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            participantsTableView.leadingAnchor.constraint(equalTo: participantsPanel.leadingAnchor, constant: 10),
            participantsTableView.trailingAnchor.constraint(equalTo: participantsPanel.trailingAnchor, constant: -10),
            participantsTableView.bottomAnchor.constraint(equalTo: participantsPanel.bottomAnchor, constant: -8)
        ])
    }

    func toggleParticipantsPanel() {
        refreshParticipants()
        participantsPanel.isHidden.toggle()
        if !participantsPanel.isHidden { view.bringSubviewToFront(participantsPanel) }
    }

    @objc private func closeParticipantsPanel() {
        participantsPanel.isHidden = true
    }

    func refreshParticipants() {
        DispatchQueue.main.async { [weak self] in
            guard let self, let session = ZoomVideoSDK.shareInstance()?.getSession(), let myself = session.getMySelf() else { return }
            self.participants = ([myself] + (session.getRemoteUsers() ?? [])).sorted { first, second in
                self.participantRoleRank(first) < self.participantRoleRank(second)
            }
            self.participantCountLabel.text = "\(self.participants.count) in this classroom"
            self.participantsBarItem.badgeValue = self.participants.count > 1 ? "\(self.participants.count)" : nil
            self.participantsTableView.reloadData()
        }
    }

    private func participantRoleRank(_ user: ZoomVideoSDKUser) -> Int {
        user.isHost() || user.isManager() ? 0 : 1
    }

    private func setupAnnotationPanel() {
        annotationPanel.translatesAutoresizingMaskIntoConstraints = false
        annotationPanel.layer.cornerRadius = 22
        annotationPanel.clipsToBounds = true
        annotationPanel.isHidden = true
        view.addSubview(annotationPanel)

        annotationStatusLabel.text = "ANNOTATE"
        annotationStatusLabel.font = .systemFont(ofSize: 10, weight: .heavy)
        annotationStatusLabel.textColor = UIColor(red: 0.67, green: 0.79, blue: 1, alpha: 1)
        annotationStatusLabel.textAlignment = .center

        let tools = [
            annotationButton(icon: "pencil", title: "Pen", tag: 0),
            annotationButton(icon: "highlighter", title: "Mark", tag: 1),
            annotationButton(icon: "arrow.up.right", title: "Arrow", tag: 2),
            annotationButton(icon: "eraser", title: "Erase", tag: 3)
        ]
        annotationToolButtons = tools
        let toolRow = UIStackView(arrangedSubviews: tools)
        toolRow.axis = .horizontal; toolRow.distribution = .fillEqually

        let colors: [UIColor] = [.systemRed, .systemYellow, .systemBlue, .systemGreen]
        let colorRow = UIStackView()
        colorRow.axis = .horizontal; colorRow.distribution = .equalSpacing
        colorRow.alignment = .center
        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .system)
            button.tag = index
            button.backgroundColor = color
            button.layer.cornerRadius = 13
            button.layer.borderWidth = index == 0 ? 3 : 0
            button.layer.borderColor = UIColor.white.cgColor
            button.addTarget(self, action: #selector(annotationColorTapped(_:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 26).isActive = true
            button.heightAnchor.constraint(equalToConstant: 26).isActive = true
            colorRow.addArrangedSubview(button)
            annotationColorButtons.append(button)
        }

        let historyRow = UIStackView(arrangedSubviews: [
            actionButton(icon: "arrow.uturn.backward", title: "Undo", action: #selector(annotationUndoTapped)),
            actionButton(icon: "arrow.uturn.forward", title: "Redo", action: #selector(annotationRedoTapped)),
            actionButton(icon: "trash", title: "Clear", action: #selector(annotationClearTapped), destructive: true)
        ])
        historyRow.axis = .horizontal; historyRow.distribution = .fillEqually

        let dividerOne = divider()
        let dividerTwo = divider()
        let content = UIStackView(arrangedSubviews: [annotationStatusLabel, toolRow, dividerOne, colorRow, dividerTwo, historyRow])
        content.axis = .vertical; content.spacing = 9
        content.translatesAutoresizingMaskIntoConstraints = false
        annotationPanel.contentView.addSubview(content)
        NSLayoutConstraint.activate([
            annotationPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            annotationPanel.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16),
            annotationPanel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.88),
            content.topAnchor.constraint(equalTo: annotationPanel.contentView.topAnchor, constant: 13),
            content.leadingAnchor.constraint(equalTo: annotationPanel.contentView.leadingAnchor, constant: 12),
            content.trailingAnchor.constraint(equalTo: annotationPanel.contentView.trailingAnchor, constant: -12),
            content.bottomAnchor.constraint(equalTo: annotationPanel.contentView.bottomAnchor, constant: -13),
            dividerOne.heightAnchor.constraint(equalToConstant: 1),
            dividerTwo.heightAnchor.constraint(equalToConstant: 1)
        ])
        selectAnnotationTool(0)
    }

    private func annotationButton(icon: String, title: String, tag: Int) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: icon)
        configuration.title = title
        configuration.imagePlacement = .top
        configuration.imagePadding = 4
        configuration.baseForegroundColor = .white
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = .systemFont(ofSize: 10, weight: .semibold)
            return updated
        }
        let button = UIButton(configuration: configuration)
        button.tag = tag
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(annotationToolTapped(_:)), for: .touchUpInside)
        return button
    }

    private func actionButton(icon: String, title: String, action: Selector, destructive: Bool = false) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: icon)
        configuration.title = title
        configuration.imagePadding = 5
        configuration.baseForegroundColor = destructive ? UIColor.systemPink : .white
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = .systemFont(ofSize: 12, weight: .semibold)
            return updated
        }
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func divider() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        return line
    }

    @objc private func annotationToolTapped(_ sender: UIButton) {
        selectAnnotationTool(sender.tag)
    }

    private func selectAnnotationTool(_ index: Int) {
        guard let helper = annotationHelper, annotationStarted else { return }
        switch index {
        case 0: helper.setToolType(.pen); helper.setToolWidth(3)
        case 1: helper.setToolType(.highLighter); helper.setToolWidth(12)
        case 2: helper.setToolType(.autoArrow); helper.setToolWidth(4)
        case 3: helper.setToolType(.ERASER); helper.setToolWidth(16)
        default: return
        }
        if index != 3 { helper.setToolColor(selectedAnnotationColor) }
        for button in annotationToolButtons {
            button.backgroundColor = button.tag == index ? UIColor.white.withAlphaComponent(0.20) : .clear
        }
    }

    @objc private func annotationColorTapped(_ sender: UIButton) {
        let colors: [UIColor] = [.systemRed, .systemYellow, .systemBlue, .systemGreen]
        selectedAnnotationColor = colors[sender.tag]
        annotationHelper?.setToolColor(selectedAnnotationColor)
        for button in annotationColorButtons {
            button.layer.borderWidth = button == sender ? 3 : 0
        }
    }

    @objc private func annotationUndoTapped() { annotationHelper?.undo() }
    @objc private func annotationRedoTapped() { annotationHelper?.redo() }

    @objc private func annotationClearTapped() {
        let alert = UIAlertController(title: "Clear annotations?", message: "This removes all annotations from the shared lesson for everyone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear all", style: .destructive) { [weak self] _ in
            self?.annotationHelper?.clear(.all)
        })
        present(alert, animated: true)
    }

    func presentJWTAlert() {
        let alert = UIAlertController(
            title: "JWT Token Required",
            message: "You can choose to copy and paste your generated JWT Token here OR leave it empty if you have added it in the SessionView+Extension jwtToken variable.",
            preferredStyle: .alert
        )
        
        // Add TextField
        alert.addTextField { textField in
            textField.placeholder = "Enter your JWT Token"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        
        // Join button
        let joinAction = UIAlertAction(title: "Join", style: .default) { _ in
            self.userInputJWT = alert.textFields?.first?.text ?? ""
            self.joinSession()
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(joinAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func addLocalViewToGrid() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black

        localView.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = createPlaceholderView(with: username)
        localPlaceholder = placeholder

        containerView.addSubview(localView)
        containerView.addSubview(placeholder)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0 / videoViewAspectRatio),

            localView.topAnchor.constraint(equalTo: containerView.topAnchor),
            localView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            localView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            localView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            placeholder.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeholder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        videoStackView.addArrangedSubview(containerView)
    }
    
    func addLocalViewDuringShare() -> (view: UIView, placeholder: UIView) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black

        let userView = UIView()
        let placeholderView = createPlaceholderView(with: username)

        userView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(userView)
        containerView.addSubview(placeholderView)
        
        localViewDuringShare.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: localViewDuringShare.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: localViewDuringShare.widthAnchor),
            
            userView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            placeholderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        return (userView, placeholderView)
    }

    func addRemoteUserView(for user: ZoomVideoSDKUser) -> (view: UIView, placeholder: UIView) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black

        let userView = UIView()
        let placeholderView = createPlaceholderView(with: user.getName() ?? "")

        userView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(userView)
        containerView.addSubview(placeholderView)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0 / videoViewAspectRatio),

            userView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            placeholderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        videoStackView.addArrangedSubview(containerView)

        return (userView, placeholderView)
    }
    
    func presentLessonPicker() {
        let alert = UIAlertController(title: "Choose a Math Lab", message: "Each handout includes annotation space and a worked-solutions page.", preferredStyle: .alert)
        let lessons = [
            ("Linear Equations", "Linear_Equations_Annotation_Lab"),
            ("Quadratic Functions", "Quadratic_Functions_Challenge"),
            ("Systems of Equations", "Systems_of_Equations_Investigation")
        ]
        for (title, resource) in lessons {
            alert.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.selectedLessonPDF = resource
                self?.handleShareSelection(with: .ShareWithView)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func openBundledPDF() {
        if let pdfURL = Bundle.main.url(forResource: selectedLessonPDF, withExtension: "pdf") {
            if let pdfDoc = PDFDocument(url: pdfURL) {
                sharedPDFView.autoScales = true
                sharedPDFView.document = pdfDoc
                sharedPDFView.isHidden = false
                shareBtnStackView.isHidden = true
            }
        } else {
            print("Could not find Math Lab PDF in bundle")
        }
    }
    
    @objc func toggleDraw() {
        guard let shareHelper = ZoomVideoSDK.shareInstance()?.getShareHelper() else { return }
        
        shareHelper.disableViewerAnnotation(false)
        
        guard shareHelper.isAnnotationFeatureSupport(), !shareHelper.isViewerAnnotationDisabled() else {
            showError(message: "Annotation is not supported", dismiss: false)
            return
        }
        
        if annotationHelper != nil {
            shareHelper.destroy(annotationHelper)
        }
        
        if shareHelper.isSharingOut() {
            guard sharedPDFView.document != nil else {
                showError(message: "Select a PDF first.", dismiss: false)
                return
            }
            annotationHelper = shareHelper.createAnnotationHelper(nil) // Nil for self sharing as mentioned for shareHelper.createAnnotationHelper
        } else if shareHelper.isOtherSharing() {
            annotationHelper = shareHelper.createAnnotationHelper(sharerView)
        }
        
        guard let annotationHelper = annotationHelper else {
            showError(message: "You are not allowed to annotate", dismiss: false)
            return
        }
        
        if annotationStarted {
            let error = annotationHelper.stopAnnotation()
            if error == .Errors_Success {
                // Removing the helper releases its gesture-catching annotation overlay so PDFKit
                // can receive pinch and pan gestures again after annotation is dismissed.
                shareHelper.destroy(annotationHelper)
                self.annotationHelper = nil
                if case .InAppScreenShare? = chosenShareType {
                    shareHelper.setAnnotationView(nil)
                }
                setPDFNavigationEnabled(true)
                shareDrawBtn.setImage(UIImage(systemName: "pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                annotationStarted = false
                annotationPanel.isHidden = true
            }
        } else {
            let error = annotationHelper.startAnnotation()
            if error == .Errors_Success {
                var errorInAppAnnotationResult: ZoomVideoSDKError?
                switch chosenShareType {
                case .InAppScreenShare:
                    if (shareHelper.isSharingOut()) {
                        errorInAppAnnotationResult = shareHelper.setAnnotationView(sharedPDFView)
                    } else {
                        errorInAppAnnotationResult = shareHelper.setAnnotationView(sharerView)
                    }
                    if errorInAppAnnotationResult == .Errors_Success {
                        shareDrawBtn.setImage(UIImage(systemName: "pencil.slash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                    } else {
                        print("Fail to set annotation")
                    }
                case .ShareWithView:
                    shareDrawBtn.setImage(UIImage(systemName: "pencil.slash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
                default:
                    return
                }
                annotationStarted = true
                setPDFNavigationEnabled(false)
                selectedAnnotationColor = .systemRed
                annotationPanel.isHidden = false
                selectAnnotationTool(0)
            } else {
                print("Fail to start annotation")
            }
        }
    }

    private func setPDFNavigationEnabled(_ enabled: Bool) {
        if enabled {
            disabledPDFNavigationGestures.forEach { $0.isEnabled = true }
            disabledPDFNavigationGestures.removeAll()
            sharedPDFView.isUserInteractionEnabled = true
            sharedPDFView.documentView?.isUserInteractionEnabled = true
        } else {
            let gestures = pdfScrollViews(in: sharedPDFView).flatMap { scrollView in
                [scrollView.panGestureRecognizer, scrollView.pinchGestureRecognizer].compactMap { $0 }
            }
            disabledPDFNavigationGestures = gestures
            disabledPDFNavigationGestures.forEach { $0.isEnabled = false }
        }
    }

    private func pdfScrollViews(in view: UIView) -> [UIScrollView] {
        var result = (view as? UIScrollView).map { [$0] } ?? []
        result += view.subviews.flatMap { pdfScrollViews(in: $0) }
        return result
    }
}

func createPlaceholderView(with name: String) -> UIView {
    let placeholderView = UIView()
    placeholderView.translatesAutoresizingMaskIntoConstraints = false
    placeholderView.backgroundColor = .darkGray
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let label = UILabel()
    label.text = name
    label.textColor = .white
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(label)
    placeholderView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
        imageView.heightAnchor.constraint(equalToConstant: 50),
        imageView.widthAnchor.constraint(equalToConstant: 50),

        stackView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
        stackView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
    ])

    return placeholderView
}

// Helper extensions
extension UIView {
    func center(in view: UIView, yOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset).isActive = true
    }

    func pinToSafeArea(of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func anchor(top: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}

extension SessionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        participants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = participants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath)
        let isTeacher = user.isHost() || user.isManager()
        let videoOn = user.getVideoCanvas()?.videoStatus()?.on ?? false
        let audioStatus = user.audioStatus()
        let audioOn = audioStatus?.audioType != ZoomVideoSDKAudioType.none && audioStatus?.isMuted == false

        var content = UIListContentConfiguration.subtitleCell()
        content.text = user.getName() ?? "Learner"
        content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        content.textProperties.color = UIColor(red: 0.06, green: 0.12, blue: 0.25, alpha: 1)
        let role = isTeacher ? "Teacher" : "Student"
        content.secondaryText = "\(role)  ·  Video \(videoOn ? "on" : "off")  ·  Audio \(audioOn ? "on" : "off")"
        content.secondaryTextProperties.font = .systemFont(ofSize: 12, weight: .medium)
        content.secondaryTextProperties.color = UIColor(red: 0.34, green: 0.39, blue: 0.50, alpha: 1)
        content.image = UIImage(systemName: isTeacher ? "graduationcap.fill" : "person.fill")
        content.imageProperties.tintColor = isTeacher ? UIColor(red: 0.31, green: 0.27, blue: 0.83, alpha: 1) : UIColor(red: 0.19, green: 0.45, blue: 0.79, alpha: 1)
        content.imageProperties.maximumSize = CGSize(width: 28, height: 28)
        cell.contentConfiguration = content
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 14
        cell.clipsToBounds = true
        cell.selectionStyle = .none

        let mediaIndicators = UIStackView(arrangedSubviews: [
            mediaIcon(videoOn ? "video.fill" : "video.slash.fill", active: videoOn),
            mediaIcon(audioOn ? "mic.fill" : "mic.slash.fill", active: audioOn)
        ])
        mediaIndicators.axis = .horizontal
        mediaIndicators.spacing = 9
        cell.accessoryView = mediaIndicators
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 68 }

    private func mediaIcon(_ name: String, active: Bool) -> UIImageView {
        let icon = UIImageView(image: UIImage(systemName: name))
        icon.tintColor = active ? UIColor(red: 0.14, green: 0.60, blue: 0.39, alpha: 1) : UIColor(red: 0.65, green: 0.23, blue: 0.30, alpha: 1)
        icon.preferredSymbolConfiguration = .init(pointSize: 15, weight: .semibold)
        icon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return icon
    }
}
