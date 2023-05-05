//
//  SearchViewController.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 05/05/2023.
//

import UIKit

class SearchViewController: UIViewController {

    let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    func setUpNavBar() {
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by "
        searchBar.tintColor = UIColor.lightGray
        searchBar.barTintColor = UIColor.lightGray
        navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
    }

}
