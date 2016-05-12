//
//  AlertView.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

class AlertView {

    class func showErrorMessage(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: GeneralLocalizations.Error, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: GeneralLocalizations.OK, style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

}