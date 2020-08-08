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
    var events: [EventModel] = []
    private let service: EventListService
    private var state: BehaviorRelay<EventListViewState?> = .init(value: nil)
    private(set) lazy var observableState = state.asObservable()
    
    // MARK: Lifecycle
    init(service: EventListService) {
        self.service = service
    }
    
    // MARK: - Functions
    func loadData() {
        state.accept(.loading)
        service.fetchEvents(completion: handleFetchEvents)
    }
    
    private func handleFetchEvents(_ result: Swift.Result<[EventModel], Error>) {
        switch result {
        case .failure(let error):
            state.accept(.failure)
            print("Error to fetch events - \(error)") // Send to crashlytics
        case .success(let model):
            state.accept(makeState(with: model))
        }
    }
    
    private func makeState(with events: [EventModel]) -> EventListViewState {
        let states: [EventTableViewCell.State] = events.map({ mapEvent($0) })
        
        self.events = events
        
        return .loaded(states: states)
    }
    
    private func mapEvent(_ event: EventModel) -> EventTableViewCell.State {
        // TODO: Apply font and color
        return .init(id: event.id,
                     imageURL: URL(string: event.image),
                     title: NSAttributedString(string: event.title),
                     participants: NSAttributedString(string: String(event.people.count)))
    }
}
