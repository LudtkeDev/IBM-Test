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
    
    init(router: EventListRouter, service: EventListService) {
        self.router = router
        self.service = service
    }
    
    // MARK: - Functions
    func loadData() {
        // TODO: Call service and handle data
    }
}
