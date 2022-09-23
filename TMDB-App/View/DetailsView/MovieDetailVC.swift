//
//  DetailsViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher

class MovieDetailVC: UIViewController {

    var id = 0
    
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overViewTextFiled: UITextView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        WebServices.delegate = self
       // dataFromViewController()
        WebServices.getMovieDetail(with: id)
    }
    

    
    
}

extension MovieDetailVC: WebServicesDelegate {
    func didUpdateMovies(movies: [Movie]) {
        
    }
    
    
    func didUpdateMovieDetail(movie: Movie) {
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            self.releaseLabel.text = movie.releaseDate
            self.overViewTextFiled.text = movie.overview
            self.voteAverageLabel.text = "\(movie.voteAverage)/10"
            //*
            let url = URL(string: "\(API.imageURL)\(movie.posterPath!)")
            self.imageView.kf.setImage(with: url)
        }
       
    }
    
    
}

