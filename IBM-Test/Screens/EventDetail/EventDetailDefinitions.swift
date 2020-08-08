//
//  EventDetailDefinitions.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxSwift

typealias EventDetailViewModelIO = EventDetailViewModelInput & EventDetailViewModelOutput

protocol EventDetailViewModelInput {
    func loadData()
}

protocol EventDetailViewModelOutput {
    var observableState: Observable<EventDetailViewState?> { get }
}
