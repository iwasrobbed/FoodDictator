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
    }

    // MARK: - Private Properties

    var restaurants = [Restaurant]()

    private lazy var searchField: TextField = {
        let search = TextField(cornerStyle: .All, placeholder: RestaurantLocalizations.SearchPlaceholder, cancellable: false)
        search.changedBlock = { (text: String) in
            GooglePlacesManager.sharedManager.cancelAllFetches()

            self.searchRestaurants(text)
        }
        search.endEditingBlock = {
            GooglePlacesManager.sharedManager.cancelAllFetches()
        }
        return search
    }()


    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView(frame: CGRectZero)
        table.rowHeight = 60
        table.registerClass(RestaurantCell.classForCoder(), forCellReuseIdentifier:RestaurantCell.cellReuseIdentifier)
        return table
    }()

}

// MARK: - Private API

private extension RestaurantsController {

    // MARK: - View Setup

    func setupView() {
        // TODO: Set specific city or "nearby" one day
        let title = String(format: RestaurantLocalizations.CityRestaurantsFormat, arguments: ["SJ"]).uppercaseString
        setupNavigation(title)

        setupSearchField()
        setupTableView()
    }

    func setupSearchField() {
        view.addSubview(searchField)
        searchField.snp_makeConstraints { (make) -> Void in
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
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(searchField.snp_bottom).offset(10)
        }
    }

    // MARK: - Fetching Restaurants

    func searchRestaurants(query: String = "Pizza") {
        GooglePlacesManager.sharedManager.fetchPlacesNearViv(query, type: .restaurant, success: { (places) in
            var restaurants = [Restaurant]()
            for place in places {
                restaurants.append(Restaurant(name: place.name, rating: place.rating, openNow: place.openNow))
            }
            self.restaurants = restaurants
            self.tableView.reloadData()
        }) { (_) in
            self.restaurants = [Restaurant]()
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Table View Delegate / Datasource

extension RestaurantsController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(RestaurantCell.cellReuseIdentifier) as! RestaurantCell

        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.updateMetaLabel(restaurant.openNow, rating: restaurant.rating)

        return cell
    }
    
}