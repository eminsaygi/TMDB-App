//
//  DetailsViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    var titleText = ""
    var overViewText = ""
    var relaseText = ""
    var imageUrl = ""
    var voteAverageText = 0.0
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overViewTextFiled: UITextView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataFromViewController()
        
    }
    
    func dataFromViewController(){
        titleLabel.text = titleText
        releaseLabel.text = relaseText
        overViewTextFiled.text = overViewText
        voteAverageLabel.text = "\(voteAverageText)/10"
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url)
    }
}
