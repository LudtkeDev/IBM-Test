//
//  EventDetailViewController.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxSwift

final class EventDetailViewController: UIViewController {

    // MARK: - Components
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
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
    
    private lazy var errorView: UIView = {
        guard let view = R.nib.errorView(owner: nil) else { return UIView() }
        view.setRetryButtonHandler(loadData)
        
        return view
    }()
    
    // MARK: - Properties
    private lazy var state = viewModel.observableState.observeOn(MainScheduler.asyncInstance)
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
        loadData()
    }
    
    private func bind() {
        bag.insert(state.subscribe(onNext: { [weak self] in self?.handleState($0) }))
    }
    
    // MARK: - Functions
    private func handleState(_ state: EventDetailViewState?) {
        guard let _state = state else { return }
        
        // TODO: Implement
    }
    
    private func loadData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in self?.viewModel.loadData() }
    }
}
