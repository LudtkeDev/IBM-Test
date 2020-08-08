//
//  EventListService.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 04/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import Alamofire

final class EventListService {
    func fetchEvents(completion: @escaping (Swift.Result<[EventModel], Error>) -> Void) {
        AF.request(Endpoint.fetchEvents.url, method: .get).responseJSON { response in
            
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    completion(.failure(ServerAPIError.wrongAnswerFormat(response.value)))
                    return
                }

                do {
                    let events = try JSONDecoder().decode([EventModel].self, from: jsonData)
                    completion(.success(events))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
