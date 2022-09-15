//
//  TableViewCell.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var relaseLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func dataFetch (movie: Movie){
        self.titleLabel.text = movie.title
        self.relaseLabel.text = Utils.formattedDateFromString(dateString: movie.release_date, withFormat: "dd.MM.yyyy")
    }
}
