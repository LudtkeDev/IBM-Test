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
    // Here we receive the model that we had already requested on the previous screen,
    // avoiding an unnecessary loading
    init(service: EventDetailService, event: EventModel) {
        self.service = service
        self.event = event
    }
    
    // MARK: - Functions
    func loadData() {
        state.accept(makeInitialState())
    }
    
    private func makeInitialState() -> EventDetailViewState {
        // TODO: Set fonts and colors
        //TODO: Remove "Porto Alegre" mock data
        let cupons = event.cupons.map({ String($0.discount) })
        
        return .init(imageURL: URL(string: event.image),
                     name: NSAttributedString(string: event.title),
                     peopleNumber: NSAttributedString(string: String(event.people.count)),
                     price: NSAttributedString(string: String(event.price)),
                     date: NSAttributedString(string: formatDate(event.date)),
                     local: NSAttributedString(string: "Porto Alegre"),
                     description: NSAttributedString(string: event.description),
                     cuponsDiscount: cupons)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yy"
        
        return dateFormatterGet.string(from: date)
    }
}
