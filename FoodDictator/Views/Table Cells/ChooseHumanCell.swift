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
    fileprivate static let unselectedFont = UIFont.dictatorRegular(18)
    fileprivate static let selectedFont = UIFont.dictatorBold(18)

    let photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    fileprivate let photoDiameter: CGFloat = 40

    let nameLabel = UILabel.dictatorRegularLabel("")
    let screenNameLabel = UILabel.dictatorLabel("", font: UIFont.dictatorRegular(16), color: UIColor.dictatorGrayText(), alignment: .left)
    fileprivate var radioView = UIImageView(image: UIImage(named:"UnselectedRadio")!)

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

        selectionStyle = .none
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

        photoView.backgroundColor = .gray
        photoView.fullyRound(photoDiameter, borderColor: .dictatorLine(), borderWidth: 0.5)

        photoView.snp.makeConstraints { (make) in
            make.size.equalTo(photoDiameter)
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
        }

        radioView.snp.makeConstraints { (make) in
            make.size.equalTo(20)
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
        }

        nameLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(24)
            make.left.equalTo(photoView.snp.right).offset(8)
            make.centerY.equalTo(contentView).offset(-5)
            make.right.equalTo(radioView.snp.left)
        }

        screenNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.height.equalTo(nameLabel)
            make.centerY.equalTo(contentView).offset(10)
        }
        
    }
    
}

