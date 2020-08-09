//
//  EventListViewState.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 06/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

enum EventListViewState: Equatable {
    case loading
    case loaded(states: [EventTableViewCell.State])
    case failure
}
