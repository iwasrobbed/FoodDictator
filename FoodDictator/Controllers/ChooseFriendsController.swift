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

        // TODO: Should have keyboard avoidance to shrink the table view size / show button
        // Just hit the return key on the keyboard for now
    }

    // MARK: - Private Properties

    private var humans = [Human(), Human(), Human(), Human(), Human(), Human()]

    private let searchField = TextField(cornerStyle: .All, placeholder: FriendsLocalizations.SearchPlaceholder)

    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView(frame: CGRectZero)
        table.rowHeight = 60
        table.registerClass(ChooseHumanCell.classForCoder(), forCellReuseIdentifier:ChooseHumanCell.cellReuseIdentifier)
        return table
    }()

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

    // MARK: - Actions

    @objc func chooseDictator() {
        self.navigationController?.pushViewController(DictatorController(), animated: true)
    }

}

// MARK: - Table View Delegate / Datasource

extension ChooseFriendsController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return humans.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ChooseHumanCell.cellReuseIdentifier) as! ChooseHumanCell

        let human = humans[indexPath.row]
        cell.photoView.image = human.photo
        cell.nameLabel.text = human.fullName

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChooseHumanCell
        cell.toggleSelection()
    }
    
}
