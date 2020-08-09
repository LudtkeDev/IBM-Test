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
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationIconImageView: UIImageView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var cuponsStackView: UIStackView!
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
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        nameLabel.attributedText = NSAttributedString(string: R.string.eventDetail.inputName())
        emailLabel.attributedText = NSAttributedString(string: R.string.eventDetail.inputEmail())
    }
    
    private func setupImages() {
        // TODO: Implement
    }
    
    private func setupButtons() {
        let shareButton: UIBarButtonItem = .init(barButtonSystemItem: .action,
                                                 target: self,
                                                 action: #selector(shareEvent))
        navigationItem.rightBarButtonItem = shareButton
        
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
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
        titleLabel.attributedText = _state.name
        peopleLabel.attributedText = _state.peopleNumber
        priceLabel.attributedText = _state.price
        dateLabel.attributedText = _state.date
        descriptionLabel.attributedText = _state.description
        
        _state.cuponsDiscount.forEach { discount in
            guard let cuponView = R.nib.cuponView(owner: nil) else { return }
            cuponView.setDiscount(discount)
            cuponsStackView.addArrangedSubview(cuponView)
        }
    }
    
    private func handleAddress(_ address: NSAttributedString) {
        locationLabel.attributedText = address
    }
    
    private func handleEmailError(_ errorMessage: NSAttributedString?) {
        emailErrorLabel.attributedText = errorMessage
    }
    
    private func handleGoButtonActivation(_ active: Bool) {
        // TODO: Implement and remove this code
        
        let buttonTitle = active ? "Ativo" : "Desativo"
        goButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func cleanTextFields() {
        nameInputText.text = nil
        emailInputText.text = nil
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
