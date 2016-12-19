//
//  AlertView.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

class AlertView {

    class func showErrorMessage(_ message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: GeneralLocalizations.Error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: GeneralLocalizations.OK, style: .cancel, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }

}
