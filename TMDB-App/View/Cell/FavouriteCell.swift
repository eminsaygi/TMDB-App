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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    

}
