//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
class MovieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
  
    
    var id = 0
    
    var movieModel = [Movie?]()
    var movvie = Movies?.self
    

    @IBOutlet weak var movieTable: UITableView!
    
    private var movieTableViewModel : TableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieTable.dataSource = self
        
        WebServices.delegate = self
        WebServices.getDiscoverMovies(with: 1)
        
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
        search.searchBar.placeholder = "Type something here to search movies"
        navigationItem.searchController = search
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieModel.count > 0 {
            return movieModel.count - 1
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
        id = movieModel[indexPath.row]?.id ?? 0

        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            
            detailVC?.id = id
            
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            WebServices.getSearchMovies(with: text)
        }
    }
    
    @objc private func didPullToRefresh(){
        movieModel.removeAll() // We cleaned the arrays in the array. So we blocked ram loading
        WebServices.getDiscoverMovies(with: 1)
    }
    
    
}

extension MovieListVC: WebServicesDelegate {
    func didUpdateMovieDetail(movie: Movie) {
        
    }
    
    func didUpdateMovies(movies: [Movie]) {
        self.movieModel = movies //Atama işlemi
        DispatchQueue.main.async {
            self.movieTable.refreshControl?.endRefreshing()
            self.movieTable.reloadData()
            
        }
    }
    }



