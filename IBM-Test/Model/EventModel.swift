//
//  EventModel.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import Foundation

struct EventModel: Decodable {
    let id: String
    let date: Date
    let description: String
    let image: String
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let people: [Person]
    let cupons: [Coupon]
    
    struct Person: Decodable {
        let id: String
        let name: String
        let picture: String
    }
    
    struct Coupon: Decodable {
        let id: String
        let eventId: String
        let discount: Int
    }
}
