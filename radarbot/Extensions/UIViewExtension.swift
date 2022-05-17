//
//  UIViewExtension.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 15/5/22.
//

import Foundation
import UIKit

extension UIView {
    func loadFromNib(nibName: String) -> UIView? {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self).first as? UIView
    }
}
