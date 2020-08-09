//
//  EventDetailViewModelTests.swift
//  IBM-TestTests
//
//  Created by Gustavo Ludtke on 09/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import XCTest
@testable import IBM_Test

class EventDetailViewModelTests: XCTestCase {
    var person: EventModel.Person!
    var coupon: EventModel.Coupon!
    var model: EventModel!
    fileprivate var viewModel: EventDetailViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        person = .init(id: "some id", name: "some name", picture: "some picture")
        coupon = .init(id: "some id", eventId: "some id", discount: 00)
        model = .init(id: "some id",
                      date: Date(),
                      description: "some description",
                      image: "some image",
                      longitude: 00000,
                      latitude: 00000,
                      price: 00,
                      title: "some title",
                      people: [person, person],
                      cupons: [coupon, coupon])
        
        viewModel = EventDetailViewModelMock(service: EventDetailService(), event: model)
    }
    
    func testRegistrationWithoutName() {
        viewModel.emailText = "test@mail.com"
        viewModel.registerUser()
        XCTAssertFalse(viewModel.userRegistered)
    }
    
    func testRegistrationWithoutEmail() {
        viewModel.emailText = ""
        viewModel.nameText = "test"
        viewModel.registerUser()
        XCTAssertFalse(viewModel.userRegistered)
    }
    
    func testRegistrationWithInvalidEmail() {
        viewModel.nameText = "test"
        viewModel.emailText = "test@mail"
        viewModel.registerUser()
        XCTAssertFalse(viewModel.userRegistered)
    }
    
    func testRegistrationWithValidEmailAndName() {
        viewModel.nameText = "test"
        viewModel.emailText = "test@mail.com"
        viewModel.registerUser()
        XCTAssertTrue(viewModel.userRegistered)
    }
    
    func testDataFormatter() {
        let expectedValue = "20/05/05"
        let timeInterval = Double(1534784400000)
        let formattedData = viewModel.formatDate(Date(timeIntervalSince1970: timeInterval))
        XCTAssertEqual(expectedValue, formattedData)
    }
    
    func testAddressFormatter() {
        let expectedValue = "Avenida José Bonifácio, Porto Alegre"
        viewModel.formatAddress(with: -30.0392981, and: -51.2146267)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(expectedValue, self.viewModel.addressStateRelay.value)
        }
    }
}

private class EventDetailViewModelMock: EventDetailViewModel {
    var userRegistered: Bool = false
    override func registerUser() { userRegistered = !nameText.isEmpty && emailText.isValidEmail }
}
