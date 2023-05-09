//
//  ResultsViewController.swift
//  AppPrototype
//
//  Created by Ben Cuello-Wolffe on 5/6/23.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(coordinates: CLLocationCoordinate2D, place: Place)
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with places: [Place]) {
        self.places = places
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = places[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place) { result in switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self.delegate?.didTapPlace(coordinates: coordinate, place: place)
    
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}
