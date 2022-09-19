//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    let refreshControl = UIRefreshControl()
    
    var titleText = ""
    var overViewText = ""
    var relaseText = ""
    var imageUrl = ""
    
    var movieModel = [Movie?]()
    var movieWebService = WebServices()
    
    
    @IBOutlet weak var movieTable: UITableView!
    
    private var movieTableViewModel : TableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieTable.dataSource = self
        
        WebServices.delegate = self
        WebServices.getDiscoverMovies()
        // webService.AlomofireFetch()
        
        searchController()
        
        movieTableRefreshControl()
        
    }
    
    func movieTableRefreshControl(){
        movieTable.refreshControl = UIRefreshControl()
        movieTable.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    func searchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to Search Movies"
        navigationItem.searchController = search
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieModel.count > 0 {
            return movieModel.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.movieDataFetch(movie: movieModel[indexPath.row]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        titleText = (self.movieModel[indexPath.row]?.title) ?? ""
        relaseText = Utils.formattedDateFromString(dateString: self.movieModel[indexPath.row]?.releaseDate ?? "", withFormat: "dd.MM.yyyy") ?? ""
        overViewText = (self.movieModel[indexPath.row]?.overview) ?? ""
        let imageUrl = "\(API.imageURL)\(self.movieModel[indexPath.row]?.posterPath ?? "")"
        self.imageUrl = imageUrl
        
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
        
        /*
         let details: DetailsViewController = self.storyboard?.instantiateViewController(identifier: "DetailsViewController") as!DetailsViewController
         navigationController?.pushViewController(details, animated: true)
         */
        // let url = URL(string: "\(API.imageURL)\(movieModel[indexPath.row]?.posterPath ?? "")")
        //DispatchQueue.main.async {
        
        // details.imageView.kf.setImage(with: url)
        /*
         }
         DispatchQueue.main.async {
         details.releaseLabel.text = Utils.formattedDateFromString(dateString: self.movieModel[indexPath.row]?.releaseDate ?? "", withFormat: "dd.MM.yyyy")
         details.titleLabel.text = self.movieModel[indexPath.row]?.title
         details.overViewTextFiled.text = self.movieModel[indexPath.row]?.overview
         }
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? DetailsViewController
            detailVC?.titleText = titleText
            detailVC?.relaseText = relaseText
            detailVC?.overViewText = overViewText
            detailVC?.imageUrl = imageUrl
            
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            WebServices.getDiscoverSearchMovies(with: text)
        }
    }
    
    @objc private func didPullToRefresh(){
        WebServices.getDiscoverMovies()
    }
    
}

