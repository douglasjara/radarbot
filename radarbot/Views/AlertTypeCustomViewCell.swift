//
//  AlertTypeCustomView.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 15/5/22.
//

import UIKit

@IBDesignable
final class AlertTypeCustomViewCell: UICollectionViewCell
{
    @IBOutlet private weak var alertIconImageView: UIImageView!
    @IBOutlet private weak var checkIcon: UIImageView!
    
    static let identifier = "CustomCollectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        guard let view = self.loadFromNib(nibName: "AlertTypeCustomView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        checkIcon.layer.cornerRadius = checkIcon.bounds.height/2
        alertIconImageView.layer.cornerRadius = 10
        alertIconImageView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        alertIconImageView.layer.borderWidth = 2
    }
    
    func set(alertType: AlertType, isChecked: Bool) -> Void {
        self.alertIconImageView.image = UIImage(named: alertType.getIconName())
        self.alertIconImageView.backgroundColor = alertType.getColor()
        
        if isChecked {
            check()
        } else {
            uncheck()
        }
    }
    
    func check() {
        self.checkIcon.isHidden = false
        alertIconImageView.layer.borderWidth = 6
    }
    
    func uncheck() {
        self.checkIcon.isHidden = true
        alertIconImageView.layer.borderWidth = 2
    }
       
    override func prepareForReuse() {
        super.prepareForReuse()
        self.alertIconImageView.image = nil
        self.checkIcon.isHidden = true
    }
}
