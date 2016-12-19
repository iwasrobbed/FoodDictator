//
//  RestaurantCell.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

class RestaurantCell: TableCell {

    // MARK: - Properties

    static let cellReuseIdentifier = "RestaurantCell"
    let nameLabel = UILabel.dictatorRegularLabel("")
    let metaLabel = UILabel.dictatorLabel("", font: UIFont.dictatorRegular(16), color: UIColor.dictatorGrayText(), alignment: .left)
    
    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        let insets = UIEdgeInsetsMake(0, 20, 0, 0)
        separatorInset = insets
        layoutMargins = insets
        preservesSuperviewLayoutMargins = false

        setupView()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateMetaLabel(_ openNow: Bool?, rating: Float?) {
        var openString = RestaurantLocalizations.hoursNA
        if let openNow = openNow {
            openString = openNow ? RestaurantLocalizations.openNow : RestaurantLocalizations.closed
        }

        var ratingString = RestaurantLocalizations.ratingNA
        if let rating = rating {
            ratingString = String(format: RestaurantLocalizations.ratingFormat, arguments: [rating])
        }

        metaLabel.text = [openString, ratingString].joined(separator: ", ")
    }

}

private extension RestaurantCell {

    // MARK: - View Setup

    func setupView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(metaLabel)

        nameLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(24)
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView).offset(-8)
            make.right.equalTo(contentView).offset(-10)
        }

        metaLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.height.equalTo(nameLabel)
            make.centerY.equalTo(contentView).offset(10)
        }
        
    }
    
}
