//
//  StringExtension.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 08/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
       let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let predicate = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       return predicate.evaluate(with: self)
    }
}
