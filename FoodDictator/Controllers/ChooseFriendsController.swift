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

    fileprivate let hud = HUD()

    fileprivate let humanStore = HumanStore()
    fileprivate var selectedHumans = Set<Human>()
    fileprivate var friends = [Human]()

    fileprivate var isSearching = false
    fileprivate var isSearchingWithResults: Bool {
        return isSearching && searchHumans.count > 0
    }
    fileprivate var searchHumans = [Human]()

    fileprivate lazy var searchField: TextField = {
        let search = TextField(cornerStyle: .all, placeholder: FriendsLocalizations.SearchPlaceholder, cancellable: true)
        search.beginEditingBlock = { [weak self] () in
            self?.isSearching = true
        }
        search.changedBlock = { [weak self] (text: String) in
            // TODO: TwitterKit doesn't support canceling pending requests like Alamofire
            // so we'd either need to do that ourselves or delay this change event from being called.
            // Currently, it could lead to a lagging request getting called when other requests were sent after
            self?.searchWithText(text)
        }
        search.endEditingBlock = { [weak self] () in
            self?.resetAfterSearching()
        }
        search.cancelBlock = { [weak self] () in
            self?.resetAfterSearching()
        }
        return search
    }()

    fileprivate let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.rowHeight = 60
        table.register(ChooseHumanCell.classForCoder(), forCellReuseIdentifier:ChooseHumanCell.cellReuseIdentifier)
        return table
    }()
    fileprivate let refreshControl = UIRefreshControl()

    lazy fileprivate var chooseButton: UIButton = {
        let button = UIButton.dictatorRounded(.pink, title: DictatorLocalizations.CHOOSEDICTATOR, target: self, action: #selector(ChooseFriendsController.chooseDictator))
        button.isEnabled = false
        return button
    }()

    lazy fileprivate var ejectButton: UIButton = {
        let eject = UIButton.dictatorImageOnly(UIImage(named: "EjectButton")!, target: self, action: #selector(ChooseFriendsController.eject))
        return eject
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

        // Uncomment for debugging
        //setupEjectButton()
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

    func setupButton() {
        view.addSubview(chooseButton)
        chooseButton.snp.makeConstraints { (make) -> Void in
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
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(view)
            make.top.equalTo(searchField.snp.bottom).offset(10)
            make.bottom.equalTo(chooseButton.snp.top).offset(-10)
        }
    }

    func setupRefreshView() {
        refreshControl.tintColor = .dictatorPink()
        refreshControl.addTarget(self, action: #selector(ChooseFriendsController.fetchTwitterFriendsAndMe), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    func setupEjectButton() {
        view.addSubview(ejectButton)
        ejectButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(DictatorNavigationBar.buttonEdgeSize)
            make.top.equalTo(view).offset(DictatorNavigationBar.buttonTopOffset)
            make.left.equalTo(view).offset(10)
        }
    }

    // MARK: - Saved Humans

    func restoreSavedHumans() {
        if let humans = humanStore.retrieveAll() {
            selectedHumans = humans
        }
    }

    // MARK: - Twitter

    @objc func fetchTwitterFriendsAndMe() {
        hud.show()
        
        if let currentHuman = TwitterManager.sharedManager.currentHuman {
            insertCurrentHumanAndFetchFriends(currentHuman)
        } else {
            TwitterManager.sharedManager.fetchCurrentHuman({ (currentHuman) in
                self.insertCurrentHumanAndFetchFriends(currentHuman)
            }) { (errorMessage) in
                self.hud.hide()
                self.showFetchErrorMessage(errorMessage)
            }
        }
    }

    func insertCurrentHumanAndFetchFriends(_ currentHuman: Human) {
        selectedHumans.removeAll()
        friends.removeAll()
        friends.insert(currentHuman, at: 0)
        fetchTwitterFriends()
    }

    func fetchTwitterFriends() {
        TwitterManager.sharedManager.fetchFriends({ (humans) in
            self.updateTableWithTwitterFriends(humans)
            self.chooseButton.isEnabled = true
        }) { (errorMessage) in
            self.showFetchErrorMessage(errorMessage)
            self.refreshControl.endRefreshing()
            self.hud.hide()
        }
    }

    func updateTableWithTwitterFriends(_ humans: [Human]) {
        friends.append(contentsOf: humans)
        restoreSavedHumans()
        for selectedHuman in selectedHumans {
            if !friends.contains(selectedHuman) {
                let index = friends.count > 0 ? 1 : 0
                friends.insert(selectedHuman, at: index)
            }
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
        hud.hide()
    }

    // MARK: - Search

    func searchWithText(_ text: String) {
        if text.characters.count == 0 {
            tableView.reloadData()
        } else {
            tableView.isUserInteractionEnabled = false

            TwitterManager.sharedManager.searchUsers(text, success: { (searchHumans) in
                self.searchHumans = searchHumans
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = true
            }, error: { (errorMessage) in
                self.tableView.isUserInteractionEnabled = true
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
        let options = Array(selectedHumans)
        // arc4random_uniform is not inclusive of upper bound, so no worry about out of bounds
        let index = Int(arc4random_uniform(UInt32(options.count)))
        let dictator = options[index]

        navigationController?.pushViewController(DictatorController(human: dictator), animated: true)
    }

    @objc func eject() {
        TwitterManager.sharedManager.logOut()
    }

    // MARK: - Helper Methods

    func showFetchErrorMessage(_ errorMessage: String) {
        let message = String(format: TwitterLocalizations.FetchErrorFormat, arguments: [errorMessage])
        AlertView.showErrorMessage(message, viewController: self)
    }

    // MARK: - Selecting Humans

    func selectHuman(_ human: Human) {
        selectedHumans.insert(human)
        humanStore.store(human)
    }

    func deselectHuman(_ human: Human) {
        selectedHumans.remove(human)
        humanStore.remove(human)
    }

}

// MARK: - Table View Delegate / Datasource

extension ChooseFriendsController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchHumans.count : friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseHumanCell.cellReuseIdentifier) as! ChooseHumanCell

        let human = humanForRow(indexPath.row)
        cell.photoView.sd_setImage(with: human.photoURL)
        cell.nameLabel.text = human.fullName
        cell.screenNameLabel.text = human.screenName
        cell.humanSelected = selectedHumans.contains(human)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChooseHumanCell
        let isHumanSelected = cell.toggleSelection()

        let human = humanForRow(indexPath.row)

        if selectedHumans.contains(human) && !isHumanSelected {
            deselectHuman(human)
        }

        if isHumanSelected {
            selectHuman(human)

            if !friends.contains(human) {
                friends.insert(human, at: 0)
            }
        }
    }

    func humanForRow(_ row: NSInteger) -> Human {
        return isSearchingWithResults ? searchHumans[row] : friends[row]
    }

}
