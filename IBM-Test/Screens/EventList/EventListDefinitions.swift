//
//  EventListDefinitions.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 06/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxSwift

typealias EventListViewModelIO = EventListViewModelInput & EventListViewModelOutput

protocol EventListViewModelInput {
    func loadData()
}

protocol EventListViewModelOutput {
    var observableState: Observable<EventListViewState?> { get }
}

protocol EventListRouting {
    func navigateToEventDetail()
}
