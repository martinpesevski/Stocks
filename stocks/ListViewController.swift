//
//  ListViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var stocks: [Stock] = []
    var filteredStocks: [Stock] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        let stock = filteredStocks[indexPath.row]
        cell.setup(stock: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStocks.count
    }
}

extension ListViewController: SortControllerDelegate, FilterDelegate {
    @IBAction func onFilter(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let filter = storyboard.instantiateViewController(withIdentifier: "filterVC") as? FilterViewController else { return }

        filter.isModal = true
        filter.stocks = stocks
        filter.delegate = self
        present(filter, animated: true, completion: nil)
    }

    func didFinishFiltering(stocks: [Stock], filteredStocks: [Stock]) {
        self.stocks = stocks
        self.filteredStocks = filteredStocks
        tableView.reloadData()
    }

    @IBAction func onSort(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sort = storyboard.instantiateViewController(withIdentifier: "sortVC") as? SortViewController else { return }

        sort.stocks = filteredStocks
        sort.delegate = self
        present(sort, animated: true, completion: nil)
    }

    func didSort(stocks: [Stock]) {
        self.filteredStocks = stocks
        tableView.reloadData()
    }
}
