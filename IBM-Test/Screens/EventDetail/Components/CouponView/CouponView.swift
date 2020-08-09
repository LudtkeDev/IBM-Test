//
//  CouponView.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 08/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class CouponView: UIView {
    
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
        imageView.image = R.image.couponIcon()
        
    }
    
    // MARK: - Functions
    func setDiscount(_ discount: String) {
        // TODO: Set font and color
        label.font = R.font.louisGeorgeCafe(size: 18)!
        label.text = R.string.eventDetail.discount(discount)
    }
}
