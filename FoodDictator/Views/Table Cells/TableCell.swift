//
//  TableCell.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension TableCell {

    func setupView() {
        self.clipsToBounds = true

        let selectionView = UIView()
        selectionView.backgroundColor = .dictatorCellSelection()
        selectedBackgroundView = selectionView
    }
    
}
