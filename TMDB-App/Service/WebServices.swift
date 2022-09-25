//
//  WebServices.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation
import UIKit



 class WebServices {
    
    
    
    static var delegate: WebServicesDelegate?
    
    // MARK: - URLSession
    
    static func getDiscoverMovies(with page: Int ) {
        
        let discoverURL = URL(string: API.discoverURL+"&page=\(page)")
        URLSession.shared.dataTask(with: discoverURL!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(Movies.self, from: safeData)
                    self.delegate?.didUpdateMovies(movies: jsonData.results!)
                    
                }
            } catch {
                
                print("Error: \(error)")
            }
        }.resume()
        
        
    }
    
    static func getSearchMovies(with query: String) {
        let searchURL = URL(string: (API.searchURL) + (query))
        URLSession.shared.dataTask(with: searchURL!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(Movies.self, from: safeData)
                    WebServices.delegate?.didUpdateMovies(movies: jsonData.results!)
                    
                    
                }
            } catch {
                print("Error")
            }
        }.resume()
        
        
    }
    
    static func getMovieDetail(with id: Int) {
        let searchURL = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=464f8a5567ef6de84d256d195532ca13&language=en-US")
        URLSession.shared.dataTask(with: searchURL!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(Movie.self, from: safeData)
                    WebServices.delegate?.didUpdateMovieDetail(movie: jsonData)
                    
                    
                }
            } catch {
                print("Error")
            }
        }.resume()
        
        
    }
    
    
    
}
// MARK: - We used delegate to call from other classes

protocol WebServicesDelegate {
    func didUpdateMovies(movies: [Movie])
    func didUpdateMovieDetail(movie: Movie)
}
