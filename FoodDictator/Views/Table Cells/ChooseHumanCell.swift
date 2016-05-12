//
//  ChooseHumanCell.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

class ChooseHumanCell: TableCell {

    // MARK: - Properties

    static let cellReuseIdentifier = "ChooseHumanCell"
    private static let unselectedFont = UIFont.dictatorRegular(18)
    private static let selectedFont = UIFont.dictatorBold(18)

    let photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFill
        return view
    }()
    private let photoDiameter: CGFloat = 40

    let nameLabel = UILabel.dictatorRegularLabel("")
    let screenNameLabel = UILabel.dictatorLabel("", font: UIFont.dictatorRegular(16), color: UIColor.dictatorGrayText(), alignment: .Left)
    private var radioView = UIImageView(image: UIImage(named:"UnselectedRadio")!)

    var humanSelected = false {
        didSet {
            nameLabel.font = humanSelected ? ChooseHumanCell.selectedFont : ChooseHumanCell.unselectedFont
            backgroundColor = humanSelected ? .dictatorLightGray() : .dictatorWhite()
            radioView.image = UIImage(named: humanSelected ? "SelectedRadio" : "UnselectedRadio")
        }
    }

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

    // MARK: - Actions

    @objc func toggleSelection() -> Bool {
        humanSelected = !humanSelected
        return humanSelected
    }

}

private extension ChooseHumanCell {

    // MARK: - View Setup

    func setupView() {

        contentView.addSubview(photoView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(screenNameLabel)
        contentView.addSubview(radioView)

        photoView.backgroundColor = .grayColor()
        photoView.fullyRound(photoDiameter, borderColor: .dictatorLine(), borderWidth: 0.5)

        photoView.snp_makeConstraints { (make) in
            make.size.equalTo(photoDiameter)
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
        }

        radioView.snp_makeConstraints { (make) in
            make.size.equalTo(20)
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
        }

        nameLabel.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(24)
            make.left.equalTo(photoView.snp_right).offset(8)
            make.centerY.equalTo(contentView).offset(-5)
            make.right.equalTo(radioView.snp_left)
        }

        screenNameLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.height.equalTo(nameLabel)
            make.centerY.equalTo(contentView).offset(10)
        }
        
    }
    
}

