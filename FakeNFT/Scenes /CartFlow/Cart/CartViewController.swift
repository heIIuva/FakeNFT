//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 25.03.2025.
//

import UIKit


final class CartViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var cartTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDelegate {
    
}

