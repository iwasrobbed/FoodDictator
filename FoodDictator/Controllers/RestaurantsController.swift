//
//  RestaurantsController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit

/*
 * Find scrumptious places to feast at
 */

class RestaurantsController: BaseController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        searchRestaurants()

        // TODO: Should have keyboard avoidance to shrink the table view size
        // Just hit the return key on the keyboard for now
    }

    // MARK: - Private Properties

    fileprivate let hud = HUD()
    var restaurants = [Restaurant]()

    fileprivate lazy var searchField: TextField = {
        let search = TextField(cornerStyle: .all, placeholder: RestaurantLocalizations.SearchPlaceholder, cancellable: false)
        search.changedBlock = { [weak self] (text: String) in
            GooglePlacesManager.sharedManager.cancelAllFetches()

            self?.searchRestaurants(text)
        }
        search.endEditingBlock = {
            GooglePlacesManager.sharedManager.cancelAllFetches()
        }
        return search
    }()


    fileprivate let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.rowHeight = 60
        table.register(RestaurantCell.classForCoder(), forCellReuseIdentifier:RestaurantCell.cellReuseIdentifier)
        return table
    }()

}

// MARK: - Private API

private extension RestaurantsController {

    // MARK: - View Setup

    func setupView() {
        // TODO: Set specific city or "nearby" one day
        let title = String(format: RestaurantLocalizations.CityRestaurantsFormat, arguments: ["SJ"]).uppercased()
        setupNavigation(title)

        setupSearchField()
        setupTableView()
    }

    func setupSearchField() {
        view.addSubview(searchField)
        searchField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(TextField.widthMultiplier.full)
            make.centerX.equalTo(view)
            make.height.equalTo(TextField.height.search)
            make.top.equalTo(view).offset(DictatorNavigationBar.height)
        }
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(searchField.snp.bottom).offset(10)
        }
    }

    // MARK: - Fetching Restaurants

    func searchRestaurants(_ query: String = "Pizza") {
        hud.show()

        GooglePlacesManager.sharedManager.fetchPlacesNearViv(query, type: .restaurant, success: { (places) in
            var restaurants = [Restaurant]()
            for place in places {
                restaurants.append(Restaurant(name: place.name, rating: place.rating, openNow: place.openNow))
            }
            self.restaurants = restaurants
            self.tableView.reloadData()
            self.hud.hide()
        }) { (_) in
            self.restaurants = [Restaurant]()
            self.tableView.reloadData()
            self.hud.hide()
        }
    }
    
}

// MARK: - Table View Delegate / Datasource

extension RestaurantsController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.cellReuseIdentifier) as! RestaurantCell

        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.updateMetaLabel(restaurant.openNow, rating: restaurant.rating)

        return cell
    }
    
}
