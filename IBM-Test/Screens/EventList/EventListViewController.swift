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
    
    // MARK: - Properties
    private lazy var state = viewModel.observableState.observeOn(MainScheduler.asyncInstance)
    private var cellStates: [EventTableViewCell.State] = []
    private let bag = DisposeBag()
    var viewModel: EventListViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        DispatchQueue.global(qos: .utility).async { [weak self] in self?.viewModel.loadData() }
    }
    
    // MARK: - Setup
    private func setup() {
        setupTableView()
        bind()
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
        
        switch _state {
        case .failure, .loading:
            // TODO: Implement
            print("Must implement")
        case .loaded(let states):
            cellStates = states
            tableView.reloadData()
        }
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

extension EventListViewController: UITableViewDelegate { }
