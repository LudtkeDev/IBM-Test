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
        participantsIcon.image = R.image.peopleIcon()
    }
    
    private func setupLabels() {
        titleLabel.font = R.font.louisGeorgeCafeBold(size: 18)!
        titleLabel.numberOfLines = 0
        participantsLabel.numberOfLines = 1
        participantsLabel.font = R.font.louisGeorgeCafe(size: 18)!
    }
    
    // MARK: - Functions
    func setState(_ state: State) {
        mainImageView.sd_setImage(with: state.imageURL)
        titleLabel.text = state.title
        participantsLabel.text = state.participants
    }
}

extension EventTableViewCell {
    struct State: Equatable {
        let id: String
        let imageURL: URL?
        let title: String
        let participants: String
        
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.imageURL == rhs.imageURL &&
                lhs.title == rhs.title &&
                lhs.participants == rhs.participants &&
                lhs.id == rhs.id
        }
    }
}
