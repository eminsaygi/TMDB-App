//
//  DetailsViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher

class MovieDetailVC: UIViewController {
    
    var selectedId = 0
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overViewTextFiled: UITextView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad(){
        super.viewDidLoad()
        imageView.backgroundColor = .darkGray
        
        getDetailData()
    }
    
    func getDetailData(){
        WebServices.shared.getMovieDetail(id: selectedId){ result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.titleLabel.text = success.title
                    self.releaseLabel.text = success.releaseDate
                    self.overViewTextFiled.text = success.overview
                    self.voteAverageLabel.text = "\(Int(success.voteAverage))/10"
                    let url = URL(string: "\(API.imageURL)\(success.posterPath!)")
                    self.imageView.kf.setImage(with: url)
                }
            case.failure(let error):
                print("hata",error)
            }
        }
    }
    
    
    
    
    
}







