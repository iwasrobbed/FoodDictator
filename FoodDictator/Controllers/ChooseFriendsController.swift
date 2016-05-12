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

        fetchTwitterFriendsAndMe()

        // TODO: Should have keyboard avoidance to shrink the table view size / show button
        // Just hit the return key on the keyboard for now
    }

    // MARK: - Private Properties

    private let humanStore = HumanStore()
    private var selectedHumans = Set<Human>()
    private var friends = [Human]()

    private var isSearching = false
    private var isSearchingWithResults: Bool {
        return isSearching && searchHumans.count > 0
    }
    private var searchHumans = [Human]()

    private lazy var searchField: TextField = {
        let search = TextField(cornerStyle: .All, placeholder: FriendsLocalizations.SearchPlaceholder, cancellable: true)
        search.beginEditingBlock = {
            self.isSearching = true
        }
        search.changedBlock = { (text: String) in
            // TODO: TwitterKit doesn't support canceling pending requests like Alamofire
            // so we'd either need to do that ourselves or delay this change event from being called.
            // Currently, it could lead to a lagging request getting called when other requests were sent after
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
            make.bottom.equalTo(chooseButton.snp_top).offset(-10)
        }
    }

    func setupRefreshView() {
        refreshControl.tintColor = .dictatorPink()
        refreshControl.addTarget(self, action: #selector(ChooseFriendsController.fetchTwitterFriendsAndMe), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }

    // MARK: - Saved Humans

    func restoreSavedHumans() {
        if let humans = humanStore.retrieveAll() {
            selectedHumans = humans
        }
    }

    // MARK: - Twitter

    @objc func fetchTwitterFriendsAndMe() {
        // TODO Show HUD
        if let currentHuman = TwitterManager.sharedManager.currentHuman {
            insertCurrentHumanAndFetchFriends(currentHuman)
        } else {
            TwitterManager.sharedManager.fetchCurrentHuman({ (currentHuman) in
                self.insertCurrentHumanAndFetchFriends(currentHuman)
            }) { (errorMessage) in
                self.showFetchErrorMessage(errorMessage)
            }
        }
    }

    func insertCurrentHumanAndFetchFriends(currentHuman: Human) {
        selectedHumans.removeAll()
        friends.removeAll()
        friends.insert(currentHuman, atIndex: 0)
        fetchTwitterFriends()
    }

    func fetchTwitterFriends() {
        TwitterManager.sharedManager.fetchFriends({ (humans) in
            self.updateTableWithTwitterFriends(humans)
        }) { (errorMessage) in
            self.showFetchErrorMessage(errorMessage)
        }
    }

    func updateTableWithTwitterFriends(humans: [Human]) {
        friends.appendContentsOf(humans)
        restoreSavedHumans()
        for selectedHuman in selectedHumans {
            if !friends.contains(selectedHuman) {
                let index = friends.count > 0 ? 1 : 0
                friends.insert(selectedHuman, atIndex: index)
            }
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    // MARK: - Search

    func searchWithText(text: String) {
        if text.characters.count == 0 {
            tableView.reloadData()
        } else {
            tableView.userInteractionEnabled = false

            TwitterManager.sharedManager.searchUsers(text, success: { (searchHumans) in
                self.searchHumans = searchHumans
                self.tableView.reloadData()
                self.tableView.userInteractionEnabled = true
            }, error: { (errorMessage) in
                self.tableView.userInteractionEnabled = true
                self.showFetchErrorMessage(errorMessage)
            })
        }
    }

    func resetAfterSearching() {
        searchHumans = [Human]()
        isSearching = false

        tableView.reloadData()
    }

    // MARK: - Actions

    @objc func chooseDictator() {
        let dictator = selectedHumans.first!
        navigationController?.pushViewController(DictatorController(human: dictator), animated: true)
    }

    // MARK: - Helper Methods

    func showFetchErrorMessage(errorMessage: String) {
        let message = String(format: TwitterLocalizations.FetchErrorFormat, arguments: [errorMessage])
        AlertView.showErrorMessage(message, viewController: self)
    }

    // MARK: - Selecting Humans

    func selectHuman(human: Human) {
        selectedHumans.insert(human)
        humanStore.store(human)
    }

    func deselectHuman(human: Human) {
        selectedHumans.remove(human)
        humanStore.remove(human)
    }

}

// MARK: - Table View Delegate / Datasource

extension ChooseFriendsController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchHumans.count : friends.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ChooseHumanCell.cellReuseIdentifier) as! ChooseHumanCell

        let human = humanForRow(indexPath.row)
        cell.photoView.sd_setImageWithURL(human.photoURL)
        cell.nameLabel.text = human.fullName
        cell.screenNameLabel.text = human.screenName
        cell.humanSelected = selectedHumans.contains(human)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChooseHumanCell
        let isHumanSelected = cell.toggleSelection()

        let human = humanForRow(indexPath.row)

        if selectedHumans.contains(human) && !isHumanSelected {
            deselectHuman(human)
        }

        if isHumanSelected {
            selectHuman(human)

            if !friends.contains(human) {
                friends.insert(human, atIndex: 0)
            }
        }
    }

    func humanForRow(row: NSInteger) -> Human {
        return isSearchingWithResults ? searchHumans[row] : friends[row]
    }

}
