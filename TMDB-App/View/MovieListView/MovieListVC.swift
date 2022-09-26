//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
class MovieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    private var moviesTableViewModel : MoviesTableViewModel?
    
    var selectedId = 0
    
    var movieModel = [Movie?]()
    
    @IBOutlet weak var movieTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieTable.dataSource = self
        
        searchController()
        
        movieTableRefreshControl()
        
        fetchMovieData()
        
    }
    
    
    func fetchMovieData(){
        WebServices.shared.getMovie() { result in
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.moviesTableViewModel = MoviesTableViewModel(movieList: success)
                    self.movieTable.reloadData()
                    
                }
                
            case.failure(let error):
                print(error)
            }
            
            
        }
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
        return moviesTableViewModel?.numberOfRowsInSection() ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.movieDataFetch(movie: (moviesTableViewModel?.movieList[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = moviesTableViewModel?.movieList[indexPath.row].id ?? 0
        
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            
            detailVC?.id = selectedId
            
            
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            
            WebServices.shared.getSearchMovies(query: text) { result in
                
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        
                        self.moviesTableViewModel = MoviesTableViewModel(movieList: success)
                        self.movieTable.reloadData()
                        
                    }
                    
                case.failure(let error):
                    print(error)
                }
                
                
            }
        }
    }
    
    @objc private func didPullToRefresh(){
        fetchMovieData()
        
    }
    
    
}




