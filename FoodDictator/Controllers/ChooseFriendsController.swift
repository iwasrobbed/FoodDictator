//
//  ChooseFriendsController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit

/*
 * Choose which friends to feast with
 */

class ChooseFriendsController: BaseController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchTwitterFriends()

        // TODO: Should have keyboard avoidance to shrink the table view size / show button
        // Just hit the return key on the keyboard for now
    }

    // MARK: - Private Properties

    private var humans = [Human]()

    private var isSearching = false
    private var searchHumans = [Human]()

    private lazy var searchField: TextField = {
        let search = TextField(cornerStyle: .All, placeholder: FriendsLocalizations.SearchPlaceholder, cancellable: true)
        search.beginEditingBlock = {
            self.isSearching = true
        }
        search.changedBlock = { (text: String) in
            self.searchWithText(text)
        }
        search.endEditingBlock = {
            self.resetAfterSearching()
        }
        search.cancelBlock = {
            self.resetAfterSearching()
        }
        return search
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView(frame: CGRectZero)
        table.rowHeight = 60
        table.registerClass(ChooseHumanCell.classForCoder(), forCellReuseIdentifier:ChooseHumanCell.cellReuseIdentifier)
        return table
    }()
    private let refreshControl = UIRefreshControl()

    lazy private var chooseButton: UIButton = {
        return UIButton.dictatorRounded(.Pink, title: DictatorLocalizations.CHOOSEDICTATOR, target: self, action: #selector(ChooseFriendsController.chooseDictator))
    }()

}

// MARK: - Private API

private extension ChooseFriendsController {

    // MARK: - View Setup

    func setupView() {
        setupNavigation(FriendsLocalizations.FEASTINGWITH, backButton: false)

        setupSearchField()
        setupButton()
        setupTableView()
        setupRefreshView()
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

    func setupButton() {
        view.addSubview(chooseButton)
        chooseButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(UIButton.dictatorConfig.buttonWidthPercentage)
            make.bottom.equalTo(view).offset(-20)
            make.height.equalTo(UIButton.dictatorConfig.buttonHeight)
            make.centerX.equalTo(view)
        }
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(view)
            make.top.equalTo(searchField.snp_bottom).offset(10)
            make.bottom.equalTo(chooseButton.snp_top).offset(-5)
        }
    }

    func setupRefreshView() {
        refreshControl.tintColor = .dictatorPink()
        refreshControl.addTarget(self, action: #selector(ChooseFriendsController.fetchTwitterFriends), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }

    // MARK: - Twitter

    @objc func fetchTwitterFriends() {
        // TODO Show HUD

        TwitterManager.sharedManager.fetchFriends({ (humans) in
            self.humans = humans
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (errorMessage) in
            self.showFetchErrorMessage(errorMessage)
        }
    }

    // MARK: - Search

    func searchWithText(text: String) {
        if text.characters.count == 0 {
            self.tableView.reloadData()
        } else {
            TwitterManager.sharedManager.searchUsers(text, success: { (humans) in
                self.searchHumans = humans
                self.tableView.reloadData()
            }, error: { (errorMessage) in
                self.showFetchErrorMessage(errorMessage)
            })
        }
    }

    func resetAfterSearching() {
        self.isSearching = false
        self.tableView.reloadData()
    }

    // MARK: - Actions

    @objc func chooseDictator() {
        let dictator = humans[0]
        self.navigationController?.pushViewController(DictatorController(human: dictator), animated: true)
    }

    // MARK: - Helper Methods

    func showFetchErrorMessage(errorMessage: String) {
        let message = String(format: TwitterLocalizations.FetchFriendsErrorFormat, arguments: [errorMessage])
        AlertView.showErrorMessage(message, viewController: self)
    }

}

// MARK: - Table View Delegate / Datasource

extension ChooseFriendsController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchHumans.count : humans.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ChooseHumanCell.cellReuseIdentifier) as! ChooseHumanCell

        let human = isSearching ? searchHumans[indexPath.row] : humans[indexPath.row]
        cell.photoView.sd_setImageWithURL(human.photoURL)
        cell.nameLabel.text = human.fullName
        cell.screenNameLabel.text = human.screenName
        cell.humanSelected = human.isSelected

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChooseHumanCell
        cell.toggleSelection()

        let human = isSearching ? searchHumans[indexPath.row] : humans[indexPath.row]
        human.isSelected = cell.humanSelected

        // If we found someone already in the table, toggle their selection
        if let index = humans.indexOf(human) {
            humans[index].isSelected = cell.humanSelected
        } else {
            // Otherwise, add the new person to our table for once search is finished
            humans.insert(human, atIndex: 0)
        }
    }
    
}
