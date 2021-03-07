//
//  UsersTableViewCell.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import UIKit
import Kingfisher
class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNamelabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hiddenView(isHidden: true)
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
    }
    
    
    func configure(_ results: Result) {
        firstNameLabel.text = results.name?.first
        lastNamelabel.text = results.name?.last
        phoneLabel.text = results.phone
        
        if let imageUrl = results.picture?.large {
            let url = URL(string: imageUrl)
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: url)
        }
        hiddenView(isHidden: false)
    }
    
    
    func configureFromCoreData(_ results: UsersCoreData) {
        firstNameLabel.text = results.firstName
        lastNamelabel.text = results.lastName
        phoneLabel.text = results.phone
        if let image = results.imageData {
            photoImageView.image = UIImage(data: image)
        } else {
            if let imageUrl = results.imageUrl {
                let url = URL(string: imageUrl)
                photoImageView.kf.indicatorType = .activity
                photoImageView.kf.setImage(with: url)
            }
        }
        
        hiddenView(isHidden: false)
    }
    
    
    func hiddenView(isHidden: Bool) {
        photoImageView.isHidden = isHidden
        firstNameLabel.isHidden = isHidden
        lastNamelabel.isHidden = isHidden
        phoneLabel.isHidden = isHidden
    }
    
}
