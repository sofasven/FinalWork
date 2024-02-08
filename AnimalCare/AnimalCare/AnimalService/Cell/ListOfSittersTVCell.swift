//
//  ListOfSittersTVCell.swift
//  AnimalCare
//
//  Created by Sofa on 27.01.24.
//

import UIKit

class ListOfSittersTVCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
