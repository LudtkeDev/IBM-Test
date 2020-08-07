//
//  EventTableViewCell.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 05/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit
import SDWebImage

final class EventTableViewCell: UITableViewCell {
    
    // MARK: - Components
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var participantsIcon: UIImageView!
    @IBOutlet private weak var participantsLabel: UILabel!
    
    // MARK: - Proprieties
    static let identifier = "EventTableViewCell"
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = nil
        titleLabel.attributedText = nil
        participantsLabel.attributedText = nil
    }
    
    // MARK: - Setup
    private func setup() {
        setupImages()
        setupLabels()
    }
    
    private func setupImages() {
        mainImageView.layer.cornerRadius = 10
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor = .lightGray
    }
    
    private func setupLabels() {
        titleLabel.numberOfLines = 0
        participantsLabel.numberOfLines = 1
    }
    
    // MARK: - Functions
    func setState(_ state: State) {
        mainImageView.sd_setImage(with: state.imageURL)
        titleLabel.attributedText = state.title
        participantsLabel.attributedText = state.participants
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
