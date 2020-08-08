//
//  CuponView.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 08/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class CuponView: UIView {
    
    // MARK: - Components
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        // TODO: Implement
        
    }
    
    // MARK: - Functions
    func setDiscount(_ discount: String) {
        // TODO: Set font and color
        label.attributedText = NSAttributedString(string: R.string.eventDetail.discount(discount))
    }
}
