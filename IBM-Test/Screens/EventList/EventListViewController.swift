//
//  EventListViewController.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 04/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxSwift

final class EventListViewController: UIViewController {
    
    // MARK: - Components
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var errorView: UIView = {
        guard let view = R.nib.errorView(owner: nil) else { return UIView() }
        view.setRetryButtonHandler(loadData)
        
        return view
    }()
    
    // MARK: - Properties
    private lazy var state = viewModel.observableState.observeOn(MainScheduler.asyncInstance)
    private var cellStates: [EventTableViewCell.State] = []
    private let bag = DisposeBag()
    var viewModel: EventListViewModelIO!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        title = R.string.eventList.eventList()
        setupTableView()
        bind()
        loadData()
    }
    
    private func setupTableView() {
        let identifier = EventTableViewCell.identifier
        let nib = UINib(resource: R.nib.eventTableViewCell)
        
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bind() {
        bag.insert(state.subscribe(onNext: { [weak self] in self?.handleState($0) }))
    }
    
    // MARK: - Functions
    private func handleState(_ state: EventListViewState?) {
        guard let _state = state else { return }
        
        tableView.isHidden = _state == .loading
        tableView.backgroundView = _state == .failure ? errorView : nil
        
        switch _state {
        case .failure: activityIndicator.stopAnimating()
        case .loading: activityIndicator.startAnimating()
        case .loaded(let states):
            cellStates = states
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
    private func loadData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in self?.viewModel.loadData() }
    }
}

extension EventListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = EventTableViewCell.identifier
        let state = cellStates[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setState(state)
        cell.selectionStyle = .none
    
        return cell
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToEventDetail(event: viewModel.events[indexPath.row])
    }
}

extension EventListViewController: EventListRouting {
    func navigateToEventDetail(event: EventModel) {
        let eventDetailVC = EventDetailFactory.buildScreen(event: event)
        
        navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}
