//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
class MovieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    var currentPage: Int = 1
    var totalPages: Int = 1000
    
    private var upcomingMovies: [Movie] = [Movie]()

    private var moviesTableViewModel : MoviesTableViewModel?
    
    var selectedId = 0
    
    @IBOutlet weak var movieTable: UITableView!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieTable.dataSource = self
        
        searchController()
        fetchMovieData()
    }
    
    
    func fetchMovieData(){
        WebServices.shared.getMovie(page: currentPage) { [weak self] result in
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self!.moviesTableViewModel = MoviesTableViewModel(movieList: success)
                    self!.movieTable.reloadData()
                    
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesTableViewModel?.numberOfRowsInSection() ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.movieDataFetch(movie: (moviesTableViewModel?.movieList[indexPath.row])!)
        
        if currentPage < totalPages {
            if indexPath.row == (moviesTableViewModel?.numberOfRowsInSection() ?? 2) - 1 {
                print("PAGEE",currentPage)
                currentPage += 1
                print("PAGE:", currentPage)
                fetchMovieData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = moviesTableViewModel?.movieList[indexPath.row].id ?? 0
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            
            detailVC?.selectedId = selectedId
            
            
        }
    }
    
}



extension MovieListVC {
 
    
    func searchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search movies"
        navigationItem.searchController = search
        
        movieTable.refreshControl = UIRefreshControl()
        movieTable.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    @objc private func didPullToRefresh(){
        currentPage = 1
        fetchMovieData()
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            
            WebServices.shared.getSearchMovies(query: text) { [weak self] result in
                
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        
                        self!.moviesTableViewModel = MoviesTableViewModel(movieList: success)
                        self!.movieTable.reloadData()
                        
                    }
                    
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
}

