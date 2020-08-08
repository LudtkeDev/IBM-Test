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
    @IBOutlet private weak var goButton: UIButton!
    
    // MARK: - Properties
    private lazy var state = viewModel.observableState.observeOn(MainScheduler.asyncInstance)
    private lazy var addressState = viewModel.observableAddress.observeOn(MainScheduler.asyncInstance)
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

        DispatchQueue.global(qos: .utility).async { [weak self] in self?.viewModel.loadData() }
    }
    
    private func bind() {
        bag.insert(state.subscribe(onNext: { [weak self] in self?.handleState($0) }))
        bag.insert(addressState.subscribe(onNext: { [weak self] in self?.handleAddress($0) }))
    }
    
    private func setupLabels() {
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
    }
    
    private func setupImages() {
        // TODO: Implement
    }
    
    private func setupButtons() {
        let shareButton: UIBarButtonItem = .init(barButtonSystemItem: .action,
                                                 target: self,
                                                 action: #selector(shareEvent))
        navigationItem.rightBarButtonItem = shareButton
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
        
        // TODO: Setup cupons stack view
    }
    
    private func handleAddress(_ address: NSAttributedString) {
        locationLabel.attributedText = address
    }
}

extension EventDetailViewController: EventDetailRouting {
    @objc func shareEvent() {
        let activityController = UIActivityViewController(activityItems: [viewModel.textToShare],
                                                          applicationActivities: nil)
        present(activityController, animated: true)
    }
}
