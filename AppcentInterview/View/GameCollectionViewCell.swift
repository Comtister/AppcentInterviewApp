//
//  GameCollectionViewCell.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 2.10.2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var nameLbl : UILabel!
    @IBOutlet var ratingLbl : UILabel!
    @IBOutlet var releasedDateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
