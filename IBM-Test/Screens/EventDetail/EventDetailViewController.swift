//
//  EventDetailViewController.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxSwift
import SDWebImage

final class EventDetailViewController: UIViewController {

    // MARK: - Components
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var peopleIconImageView: UIImageView!
    @IBOutlet private weak var peopleLabel: UILabel!
    @IBOutlet private weak var priceIconImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dateIconImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationIconImageView: UIImageView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var couponsStackView: UIStackView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameInputText: UITextField!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var emailInputText: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var goButton: UIButton!
    
    // MARK: - Properties
    private lazy var state = viewModel.observableState.observeOn(MainScheduler.asyncInstance)
    private lazy var addressState = viewModel.observableAddress.distinctUntilChanged().observeOn(MainScheduler.asyncInstance)
    private lazy var emailError = viewModel.observableEmailError.observeOn(MainScheduler.asyncInstance)
    private lazy var userFeedback = viewModel.observableUserFeedback.observeOn(MainScheduler.asyncInstance)
    private lazy var goButtonActivation = viewModel
        .observableGoButtonActivation
        .distinctUntilChanged()
        .observeOn(MainScheduler.asyncInstance)
    private let bag = DisposeBag()
    var viewModel: EventDetailViewModelIO!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        bind()
        setupLabels()
        setupImages()
        setupButtons()
        setupTextInputs()
        setupNotifications()

        DispatchQueue.global(qos: .utility).async { [weak self] in self?.viewModel.loadData() }
    }
    
    private func bind() {
        bag.insert(state.subscribe(onNext: { [weak self] in self?.handleState($0) }))
        bag.insert(addressState.subscribe(onNext: { [weak self] in self?.handleAddress($0) }))
        bag.insert(emailError.subscribe(onNext: { [weak self] in self?.handleEmailError($0) }))
        bag.insert(goButtonActivation.subscribe(onNext: { [weak self] in self?.handleGoButtonActivation($0) }))
        bag.insert(userFeedback.subscribe(onNext: { [weak self] in self?.showUserFeedback($0) }))
    }
    
    private func setupLabels() {
        let regularFont = R.font.louisGeorgeCafe(size: 18)!
        let boldFont = R.font.louisGeorgeCafeBold(size: 22)!
        let descriptionFont = R.font.gontserratRegular(size: 15)!
        let errorFont = R.font.gontserratRegular(size: 12)!
        
        titleLabel.font = boldFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        peopleLabel.font = regularFont
        priceLabel.font = regularFont
        dateLabel.font = regularFont
        locationLabel.font = regularFont
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .justified
        descriptionLabel.font = descriptionFont
        locationLabel.numberOfLines = 0
        nameLabel.attributedText = NSAttributedString(string: R.string.eventDetail.inputName())
        nameLabel.font = descriptionFont
        emailLabel.attributedText = NSAttributedString(string: R.string.eventDetail.inputEmail())
        emailLabel.font = descriptionFont
        emailErrorLabel.font = errorFont
        emailErrorLabel.textColor = .red
    }
    
    private func setupImages() {
        mainImageView.backgroundColor = .lightGray
        peopleIconImageView.image = R.image.peopleIcon()
        priceIconImageView.image = R.image.moneyIcon()
        dateIconImageView.image = R.image.calendarIcon()
        locationIconImageView.image = R.image.locationPinIcon()
    }
    
    private func setupButtons() {
        let shareButton: UIBarButtonItem = .init(barButtonSystemItem: .action,
                                                 target: self,
                                                 action: #selector(shareEvent))
        navigationItem.rightBarButtonItem = shareButton
        
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        goButton.layer.cornerRadius = 10
        goButton.layer.borderWidth = 2
        goButton.tintColor = .white
        goButton.layer.borderColor = UIColor.systemGray3.cgColor
        goButton.setAttributedTitle(NSAttributedString(string: R.string.eventDetail.goEvent(),
                                                       attributes: [.font: R.font.louisGeorgeCafeBold(size: 15)!]),
                                    for: .normal)
    }
    
    private func setupTextInputs() {
        nameInputText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailInputText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - Functions
    private func handleState(_ state: EventDetailViewState?) {
        guard let _state = state else { return }
        
        mainImageView.sd_setImage(with: _state.imageURL)
        titleLabel.text = _state.name
        peopleLabel.text = _state.peopleNumber
        priceLabel.text = _state.price
        dateLabel.text = _state.date
        descriptionLabel.text = _state.description
        
        _state.couponsDiscount.forEach { discount in
            guard let couponView = R.nib.couponView(owner: nil) else { return }
            couponView.setDiscount(discount)
            couponsStackView.addArrangedSubview(couponView)
        }
    }
    
    private func handleAddress(_ address: NSAttributedString) {
        locationLabel.attributedText = address
    }
    
    private func handleEmailError(_ errorMessage: NSAttributedString?) {
        emailErrorLabel.attributedText = errorMessage
    }
    
    private func handleGoButtonActivation(_ active: Bool) {
        let backgroundColor: UIColor = active ? .systemRed : .systemGray
        goButton.layer.backgroundColor = backgroundColor.cgColor
    }
    
    private func cleanTextFields() {
        nameInputText.text = nil
        emailInputText.text = nil
        viewModel.emailText = ""
        viewModel.nameText = ""
    }
    
    @objc private func goButtonTapped() {
        DispatchQueue.main.async { [weak self] in self?.viewModel.registerUser() }
    }
    
    @objc private func textFieldDidChange() {
        if nameInputText.isFirstResponder {
            viewModel.nameText = nameInputText.text ?? ""
        } else {
            viewModel.emailText = emailInputText.text ?? ""
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension EventDetailViewController: EventDetailRouting {
    @objc func shareEvent() {
        let activityController = UIActivityViewController(activityItems: [viewModel.textToShare],
                                                          applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    func showUserFeedback(_ success: Bool) {
        let title = success ? R.string.general.success() : R.string.general.error()
        let message = success ? R.string.eventDetail.checkInSuccessMessage() : R.string.eventDetail.checkInErrorMessage()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.general.ok(), style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true)
        
        cleanTextFields()
    }
}
