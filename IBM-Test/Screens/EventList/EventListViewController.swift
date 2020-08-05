//
//  EventListViewController.swift
//  IBM-Test
//
//  Created by Gustavo Ludtke on 04/08/20.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

final class EventListViewController: UIViewController {
    
    // MARK: - Components
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
}
