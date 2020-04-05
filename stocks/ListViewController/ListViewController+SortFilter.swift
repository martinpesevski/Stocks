//
//  ListViewController+SortFilter.swift
//  stocks
//
//  Created by Martin Peshevski on 4/5/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

extension ListViewController: SortControllerDelegate, FilterDelegate {
    @objc func onFilter() {
        let filter = FilterViewController(viewModel: viewModel)
        filter.isModal = true
        filter.delegate = self
        present(filter, animated: true, completion: nil)
    }

    func didFinishFiltering() {
        tableView.reloadData()
    }

    @objc func onSort() {
        let sort = SortViewController(viewModel: viewModel)
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
