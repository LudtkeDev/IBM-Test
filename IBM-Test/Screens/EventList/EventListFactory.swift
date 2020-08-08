//
//  EventListFactory.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 06/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class EventListFactory {
    static func buildScreen() -> UIViewController {
        let router = EventListRouter()
        let service = EventListService()
        let viewModel = EventListViewModel(router: router, service: service)
        let storyboard = R.storyboard.eventListViewController()
        let identifier = "EventListViewController"
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? EventListViewController
        
        viewController?.viewModel = viewModel
        
        return viewController ?? UIViewController()
    }
}
