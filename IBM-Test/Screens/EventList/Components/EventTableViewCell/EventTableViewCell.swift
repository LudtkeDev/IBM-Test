//
//  EventTableViewCell.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 05/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class EventTableViewCell: UITableViewCell {
    
    // MARK: - Components
    @IBOutlet private weak var mainImageView: UIImageView!
    
    // MARK: - Proprieties
    static let identifier = "EventTableViewCell"
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // TODO: Clear data
    }
    
    // MARK: - Setup
    private func setup() {
        setupImage()
        setupLabels()
    }
    
    private func setupImage() {
        mainImageView.layer.cornerRadius = 4
    }
    
    private func setupLabels() {
        // TODO: Implement
    }
    
    // MARK: - Functions
    func setState(_ state: State) {
        // TODO: Set state
    }
}

extension EventTableViewCell {
    struct State: Equatable {
        let imageURL: URL?
        let title: NSAttributedString
        let participants: NSAttributedString
        
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.imageURL == rhs.imageURL &&
                lhs.title == rhs.title &&
                lhs.participants == rhs.participants
        }
    }
}
