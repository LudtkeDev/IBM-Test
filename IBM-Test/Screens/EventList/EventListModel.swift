//
//  EventListModel.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 04/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

struct EventListModel: Decodable {
    struct Event: Decodable {
        let id: String
        let title: String
        let image: String
        let people: [Person]
    }
    
    struct Person: Decodable {
        let id: String
        let name: String
        let picture: String
    }
}

