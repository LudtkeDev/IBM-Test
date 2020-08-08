//
//  EventDetailViewModel.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxRelay

final class EventDetailViewModel: EventDetailViewModelIO {
    // MARK: - Properties
    private let service: EventDetailService
    private let event: EventModel
    private var state: BehaviorRelay<EventDetailViewState?> = .init(value: nil)
    private(set) lazy var observableState = state.asObservable()
    
    // MARK: - Lifecycle
    init(service: EventDetailService, event: EventModel) {
        self.service = service
        self.event = event
    }
    
    // MARK: - Functions
    func loadData() {
        // TODO: Implement
    }
}
