//
//  EventDetailViewModel.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import RxRelay
import CoreLocation

final class EventDetailViewModel: EventDetailViewModelIO {
    // MARK: - Properties
    private let service: EventDetailService
    private let event: EventModel
    private var state: BehaviorRelay<EventDetailViewState?> = .init(value: nil)
    private var addressState: PublishRelay<NSAttributedString> = .init()
    private(set) var textToShare: String
    private(set) lazy var observableState = state.asObservable()
    private(set) lazy var observableAddress = addressState.asObservable()
    
    // MARK: - Lifecycle
    // Here we receive the model that we had already requested on the previous screen,
    // avoiding an unnecessary loading and request
    init(service: EventDetailService, event: EventModel) {
        self.service = service
        self.event = event
        self.textToShare = event.title
    }
    
    // MARK: - Functions
    func loadData() {
        state.accept(makeInitialState())
    }
    
    private func makeInitialState() -> EventDetailViewState {
        // TODO: Set fonts and colors
        //TODO: Remove "Porto Alegre" mock data
        let cupons = event.cupons.map({ String($0.discount) })
        formatAddress(with: event.latitude, and: event.longitude)
        
        return .init(imageURL: URL(string: event.image),
                     name: NSAttributedString(string: event.title),
                     peopleNumber: NSAttributedString(string: String(event.people.count)),
                     price: NSAttributedString(string: String(event.price)),
                     date: NSAttributedString(string: formatDate(event.date)),
                     description: NSAttributedString(string: event.description),
                     cuponsDiscount: cupons)
    }
    
    // MARK: - Formatters
    private func formatDate(_ date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yy"
        
        return dateFormatterGet.string(from: date)
    }
    
    private func formatAddress(with latitude: Double, and longitude: Double) {
        let geoCoder = CLGeocoder()
        let errorString = R.string.eventDetail.addressNotFound()
        
        guard let lat = CLLocationDegrees(exactly: latitude), let lng = CLLocationDegrees(exactly: longitude) else {
            addressState.accept(NSAttributedString(string: errorString))
            return
        }
        
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            let address = NSAttributedString(string: processResponse(placemark: placemarks?.first, error: error))
            self?.addressState.accept(address)
        }
        
        func processResponse(placemark: CLPlacemark?, error: Error?) -> String {
            if let _error = error {
                print("Error to process event location - \(_error)") // Send to crashlytics
                return errorString
            }
            
            if let city = placemark?.locality, let thoroughfare = placemark?.thoroughfare {
                return R.string.eventDetail.formattedAddress(thoroughfare, city)
            }
            
            return errorString
        }
    }
}
