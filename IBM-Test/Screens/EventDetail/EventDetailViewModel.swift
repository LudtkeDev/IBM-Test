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
    private var stateRelay: BehaviorRelay<EventDetailViewState?> = .init(value: nil)
    private var addressStateRelay: PublishRelay<NSAttributedString> = .init()
    private var emailErrorMessageRelay: PublishRelay<NSAttributedString?> = .init()
    private var goButtonActivationRelay: BehaviorRelay<Bool> = .init(value: false)
    private var userFeedbackRelay: PublishRelay<Bool> = .init()
    private(set) var textToShare: String
    private(set) lazy var observableState = stateRelay.asObservable()
    private(set) lazy var observableAddress = addressStateRelay.asObservable()
    private(set) lazy var observableEmailError = emailErrorMessageRelay.asObservable()
    private(set) lazy var observableGoButtonActivation = goButtonActivationRelay.asObservable()
    private(set) lazy var observableUserFeedback = userFeedbackRelay.asObservable()
    var nameText: String = "" {
        didSet { activeRegisterButtonIfNedded() }
    }
    var emailText: String = "" {
        didSet { activeRegisterButtonIfNedded() }
    }
    
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
        stateRelay.accept(makeInitialState())
    }
    
    func registerUser() {
        let errorMessage = emailText.isValidEmail ? nil : NSAttributedString(string: R.string.eventDetail.emailError())
        emailErrorMessageRelay.accept(errorMessage)
        
        guard emailText.isValidEmail else { return }
        service.checkIn(email: emailText, name: nameText, eventId: event.id, completion: handleCheckIn)
    }
    
    private func makeInitialState() -> EventDetailViewState {
        let coupons = event.cupons.map({ String($0.discount) })
        formatAddress(with: event.latitude, and: event.longitude)
        
        return .init(imageURL: URL(string: event.image),
                     name: event.title,
                     peopleNumber: String(event.people.count),
                     price: R.string.eventDetail.price(String(event.price)),
                     date: formatDate(event.date),
                     description: event.description,
                     couponsDiscount: coupons)
    }
    
    private func activeRegisterButtonIfNedded() {
        goButtonActivationRelay.accept(!nameText.isEmpty && !emailText.isEmpty)
    }
    
    private func handleCheckIn(_ result: Swift.Result<Void, Error>) {
        switch result {
        case .success:
            userFeedbackRelay.accept(true)
        case .failure(let error):
            userFeedbackRelay.accept(false)
            print("Error to checkin - \(error)") // Send to crashlytics
        }
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
            addressStateRelay.accept(NSAttributedString(string: errorString))
            return
        }
        
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            let address = NSAttributedString(string: processResponse(placemark: placemarks?.first, error: error))
            self?.addressStateRelay.accept(address)
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
