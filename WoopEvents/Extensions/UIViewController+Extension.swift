//
//  UIViewController+Extension.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-31.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String? = nil, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in handler?() }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
