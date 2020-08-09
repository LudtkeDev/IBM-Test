//
//  ErrorView.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 07/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class ErrorView: UIView {
    // MARK: - Components
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    
    // MARK: - Properties
    private var retryButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.attributedText = NSAttributedString(string: R.string.general.requestError())
        
        retryButton.setAttributedTitle(NSAttributedString(string: R.string.general.tryAgain()), for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Functions
    func setRetryButtonHandler(_ handler: @escaping () -> Void) {
        retryButtonHandler = handler
    }
    
    @objc private func retryButtonTapped() {
        retryButtonHandler?()
    }
}
