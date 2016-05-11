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
    }

    // MARK: - Private Properties

    var restaurants = [Restaurant(), Restaurant(), Restaurant(), Restaurant(), Restaurant()]

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

        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(DictatorNavigationBar.height)
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
        cell.photoView.image = restaurant.photo

        // TODO: Display other meta data like rating?

        return cell
    }
    
}