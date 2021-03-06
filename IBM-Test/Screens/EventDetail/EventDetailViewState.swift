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
    let name: String
    let peopleNumber: String
    let price: String
    let date: String
    let description: String
    let couponsDiscount: [String]
}
