//
//  HeaderTableViewCell.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import UIKit
import Kingfisher

protocol HeaderTableViewCellDelegate {
    func buttonPressed()
}

class HeaderTableViewCell: UITableViewCell {

    var delegate: HeaderTableViewCellDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
       
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.backgroundColor = .red
       
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.buttonPressed()
    }
    
    func configure(_ image: UIImage?) {
        profileImageView.image = image
    }
    
    func setUpImage(_ imageString: String?) {
        if let imageUrl = imageString {
            if let url = URL(string: imageUrl) {
                profileImageView.kf.indicatorType = .activity
                profileImageView.kf.setImage(with: url)
            }
        }

    }
    
}
