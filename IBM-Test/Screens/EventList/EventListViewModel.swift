//
//  EventListViewModel.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 04/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxRelay

final class EventListViewModel: EventListViewModelIO {
    // MARK: - Properties
    private let router: EventListRouter
    private let service: EventListService
    private var state: BehaviorRelay<EventListViewState?> = .init(value: nil)
    private(set) lazy var observableState = state.asObservable()
    
    // MARK: Lifecycle
    init(router: EventListRouter, service: EventListService) {
        self.router = router
        self.service = service
    }
    
    // MARK: - Functions
    func loadData() {
        state.accept(.loading)
        service.fetchEvents(completion: handleFetchEvents)
    }
    
    private func handleFetchEvents(_ result: Swift.Result<[EventListModel.Event], Error>) {
        switch result {
        case .failure(let error):
            state.accept(.failure)
            print("Error: \(error)")
        case .success(let model):
            state.accept(makeState(with: model))
        }
    }
    
    private func makeState(with events: [EventListModel.Event]) -> EventListViewState {
        let states: [EventTableViewCell.State] = events.map({ mapEvent($0) })
        return .loaded(states: states)
    }
    
    private func mapEvent(_ event: EventListModel.Event) -> EventTableViewCell.State {
        // TODO: Apply font and color
        return .init(imageURL: URL(string: event.image),
                     title: NSAttributedString(string: event.title),
                     participants: NSAttributedString(string: String(event.people.count)))
    }
}
