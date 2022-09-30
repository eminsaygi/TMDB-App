//
//  MovieVC+Search.swift
//  TMDB-App
//
//  Created by Emin Saygı on 29.09.2022.
//

import Foundation
import UIKit

extension MovieListVC{
    
    func searchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search movies"
        navigationItem.searchController = search
        
        movieTable.refreshControl = UIRefreshControl()
        movieTable.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
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
    @objc private func didPullToRefresh(){
        moviesData.removeAll()
        currentPage = 1
        fetchMovieData()
        lblTitle.text = "Top Rated"

        
    }
    
    
}
