//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit

class MovieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    var currentPage: Int = 1
    
    private var moviesData: [Movie] = [Movie]()
    private var isFetchData : Bool = false
    
    
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
        WebServices.shared.getMovie(page: currentPage) {  result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.moviesData.append(contentsOf: data)
                   // self.moviesData = data
                    print("yakala" ,self.moviesData)
                    self.movieTable.reloadData()
                    self.currentPage += 1
                    
                    
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.movieDataFetch(movie: (moviesData[indexPath.row]))
        
     
    
        return cell
    }
    
 
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = moviesData[indexPath.row].id ?? 0
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    
    
    
}

extension MovieListVC: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= moviesData.count - 3 {
                fetchMovieData()
                print("Page:" , currentPage)

                
            }
        }
    }
    
    
}



extension MovieListVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            
            detailVC?.selectedId = selectedId
            
            
        }
    }
    
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
        moviesData.removeAll()
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
                        
                        self!.moviesData = success
                        self!.movieTable.reloadData()
                        
                    }
                    
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
}

