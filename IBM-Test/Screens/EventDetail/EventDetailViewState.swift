//
//  EventDetailViewState.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import Foundation

struct EventDetailViewState: Equatable {
    let imageURL: URL?
    let name: NSAttributedString
    let peopleNumber: NSAttributedString
    let price: NSAttributedString
    let date: NSAttributedString
    let local: NSAttributedString
    let description: NSAttributedString
    let cuponsDiscount: [String]
}
