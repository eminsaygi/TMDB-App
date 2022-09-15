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
    
    @IBOutlet weak var overViewTextFiled: UITextView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        releaseLabel.text = relaseText
        overViewTextFiled.text = overViewText
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url)
        
    }
    
    
}
