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
    func registerUser()
    var nameText: String { get set }
    var emailText: String { get set }
}

protocol EventDetailViewModelOutput {
    var observableState: Observable<EventDetailViewState?> { get }
    var observableAddress: Observable<NSAttributedString> { get }
    var observableEmailError: Observable<NSAttributedString?> { get }
    var observableGoButtonActivation: Observable<Bool> { get }
    var observableUserFeedback: Observable<Bool> { get }
    var textToShare: String { get }
}

protocol EventDetailRouting {
    func shareEvent()
    func showUserFeedback(_ success: Bool)
}
