//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var movieModel = [Movie?]()
    
    var movieWebService = WebServices()
    
    
    @IBOutlet weak var movieTable: UITableView!
    
    
    private var movieTableViewModel : TableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTable.delegate = self
        movieTable.dataSource = self
        
        movieWebService.delegate = self
        movieWebService.getDiscoverMovies()
        // webService.AlomofireFetch()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.dataFetch(movie: movieModel[indexPath.row]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details: DetailsViewController = self.storyboard?.instantiateViewController(identifier: "DetailsViewController") as!DetailsViewController
        navigationController?.pushViewController(details, animated: true)
        
        
        
        let url = URL(string: "\(API.imageURL)\(movieModel[indexPath.row]?.posterPath ?? "")")
        
        DispatchQueue.main.async {
            details.imageView.kf.setImage(with: url)
        }
        
        
        
        DispatchQueue.main.async {
            details.releaseLabel.text = Utils.formattedDateFromString(dateString: self.movieModel[indexPath.row]?.releaseDate ?? "", withFormat: "dd.MM.yyyy")
            details.titleLabel.text = self.movieModel[indexPath.row]?.title
            details.overViewTextFiled.text = self.movieModel[indexPath.row]?.overview
            
        }
        
        
    }
    
    
    
}
