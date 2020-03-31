//
//  ListViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: StocksViewModel!

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        performSegue(withIdentifier: "detail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? StockDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }

        destination.stock = viewModel.filteredStocks[indexPath.row]
    }
}

extension ListViewController: SortControllerDelegate, FilterDelegate {
    @IBAction func onFilter(_ sender: Any) {
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

    @IBAction func onSort(_ sender: Any) {
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
