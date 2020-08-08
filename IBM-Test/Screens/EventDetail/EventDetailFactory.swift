//
//  EventDetailFactory.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class EventDetailFactory {
    static func buildScreen(event: EventModel) -> UIViewController {
        let service = EventDetailService()
        let viewModel = EventDetailViewModel(service: service, event: event)
        let storyboard = R.storyboard.eventDetailViewController()
        let identifier = "EventDetailViewController"
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? EventDetailViewController
        
        viewController?.viewModel = viewModel
        
        return viewController ?? UIViewController()
    }
}

