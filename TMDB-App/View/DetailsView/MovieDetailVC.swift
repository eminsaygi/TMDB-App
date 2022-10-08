//
//  DetailsViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
import CoreData

class MovieDetailVC: UIViewController {
    
     var selectedId = 0

    private var urlString = ""

    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overViewTextFiled: UITextView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        imageView.backgroundColor = .darkGray
        overViewTextFiled.text = ""
        
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
                    let voteAveragaText = Utils.convertDouble(success.voteAverage, maxDecimals: 1)
                    self.voteAverageLabel.text = "\(voteAveragaText)/10"

                    self.urlString = "\(API().imageURL)\(success.posterPath ?? "")"
                    let url = URL(string: self.urlString)
                    self.imageView.kf.setImage(with: url)


                }
            case.failure(let error):
                print("Catch",error)
            }
        }
    }
    
    

    
    
}

// MARK: - Core Data Save Section
extension MovieDetailVC {
    @IBAction func favouritesClickedButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "MoviesData", into: context)
        
        saveData.setValue(titleLabel.text, forKey: "title")
        saveData.setValue(releaseLabel.text, forKey: "releaseDate")
        saveData.setValue(voteAverageLabel.text, forKey: "voteCount")
     
        saveData.setValue(urlString, forKey: "image")
        saveData.setValue(UUID(), forKey: "id")
        saveData.setValue(selectedId, forKey: "movieId")
        do {
            try context.save()
            print("succesK")
            
        } catch {
            print("errorK")
        }
        
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "newData"), object: nil)
    }
}
