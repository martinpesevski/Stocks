//
//  ListViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class ListViewController: ViewController {
    var viewModel: StocksViewModel

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(StockCell.self, forCellReuseIdentifier: "stockCell")
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        table.separatorStyle = .none
        
        return table
    }()
    
    lazy var filterButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemGreen
        btn.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .label
        btn.layer.cornerRadius = 25
        btn.snp.makeConstraints { make in make.width.height.equalTo(50) }
        btn.addTarget(self, action: #selector(onFilter), for: .touchUpInside)
        return btn
    }()
    
    lazy var sortButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemGreen
        btn.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .label
        btn.layer.cornerRadius = 25
        btn.snp.makeConstraints { make in make.width.height.equalTo(50) }
        btn.addTarget(self, action: #selector(onSort), for: .touchUpInside)
        return btn
    }()
    
    lazy var sortFilterStack = UIStackView(views: [sortButton, filterButton], axis: .horizontal, spacing: 10)
    
    init(viewModel: StocksViewModel = StocksViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(sortFilterStack)
        
        setConstraints()
        setupSearch()
        tableView.reloadData()
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide)}
        sortFilterStack.snp.makeConstraints { make in make.bottom.trailing.equalTo(view.layoutMarginsGuide).inset(20) }
    }
    
    func setupSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search stocks"
        
        navigationItem.searchController = searchController
        navigationItem.hidesBackButton = true
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        let stock = viewModel.filteredStocks[indexPath.row]
        cell.setup(stock: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStocks.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = StockDetailViewController(stock: viewModel.filteredStocks[indexPath.row])
        show(detailVC, sender: self)
    }
}
