//
//  FavouriteCell.swift
//  TMDB-App
//
//  Created by Emin Saygı on 2.10.2022.
//

import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var relaseLabel: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = 7.0
        movieImageView.backgroundColor = .darkGray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
