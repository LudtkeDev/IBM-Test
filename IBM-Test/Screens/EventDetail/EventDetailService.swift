//
//  EventDetailService.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import Alamofire

final class EventDetailService {
    func checkIn(email: String,
                 name: String,
                 eventId: String,
                 completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        
        let parameters = ["name": name, "email": email, "eventId": eventId]
        
        AF.request(Endpoint.checkIn.url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
