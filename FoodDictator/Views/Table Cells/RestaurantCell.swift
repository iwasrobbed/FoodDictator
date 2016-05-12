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
    let nameLabel = UILabel.dictatorLabel("", font: UIFont.dictatorRegular(18), alignment: .Left)

    let photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFill
        return view
    }()
    private let photoDiameter: CGFloat = 40
    
    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .None
        let insets = UIEdgeInsetsMake(0, photoDiameter + 20, 0, 0)
        separatorInset = insets
        layoutMargins = insets
        preservesSuperviewLayoutMargins = false

        setupView()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

private extension RestaurantCell {

    // MARK: - View Setup

    func setupView() {
        contentView.addSubview(photoView)
        contentView.addSubview(nameLabel)

        photoView.backgroundColor = .grayColor()
        photoView.fullyRound(photoDiameter, borderColor: .dictatorLine(), borderWidth: 0.5)

        photoView.snp_makeConstraints { (make) in
            make.size.equalTo(photoDiameter)
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
        }

        nameLabel.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(24)
            make.left.equalTo(photoView.snp_right).offset(8)
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
        }
        
    }
    
}