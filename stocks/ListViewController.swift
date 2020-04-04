//
//  ListViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class ListViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: StocksViewModel

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(StockCell.self, forCellReuseIdentifier: "stockCell")
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        return table
    }()
    
    init(viewModel: StocksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide)}
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search stocks"
        
        navigationItem.searchController = searchController
        navigationItem.hidesBackButton = true
        definesPresentationContext = true

        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
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

extension ListViewController: SortControllerDelegate, FilterDelegate {
    @objc func onFilter(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let filter = storyboard.instantiateViewController(withIdentifier: "filterVC") as? FilterViewController else { return }

        filter.isModal = true
        filter.viewModel = viewModel
        filter.delegate = self
        present(filter, animated: true, completion: nil)
    }

    func didFinishFiltering() {
        tableView.reloadData()
    }

    @objc func onSort(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sort = storyboard.instantiateViewController(withIdentifier: "sortVC") as? SortViewController else { return }

        sort.viewModel = viewModel
        sort.delegate = self
        present(sort, animated: true, completion: nil)
    }

    func didSort() {
        tableView.reloadData()
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(searchController.searchBar.text)
        tableView.reloadData()
    }
}
