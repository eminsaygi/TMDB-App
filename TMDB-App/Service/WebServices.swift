//
//  WebServices.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation
import UIKit



final class WebServices {
    
    
    
    static var delegate: WebServicesDelegate?
    
    // MARK: - URLSession
    
    static func getDiscoverMovies() {
        
        let discoverURL = URL(string: "\(API.discoverURL)")
        URLSession.shared.dataTask(with: discoverURL!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(MovieViewModel.self, from: safeData)
                    
                    self.delegate?.didUpdateMovies(movies: jsonData.results!)
                    
                }
            } catch {
                print("Error")
            }
        }.resume()
        
        
    }
    
    static func getSearchMovies(with text: String) {
        let searchURL = URL(string: "\(API.searchURL)\(text)")
        URLSession.shared.dataTask(with: searchURL!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(MovieViewModel.self, from: safeData)
                    WebServices.delegate?.didUpdateMovies(movies: jsonData.results!)
                    
                    
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
}

// MARK: - Alamofire
/*
 static func getUpComingMovieList( successHandler: @escaping( DiscoverResponseModel?)->()){
 
 AF.request(url2).responseDecodable { (response:AFDataResponse<DiscoverResponseModel>) in
 
 switch(response.result){
 
 case .success(let responseData):
 
 successHandler(responseData)
 
 break
 
 case .failure(let error):
 
 // print("getUpComingMovieList" + error.localizedDescription)
 
 break
 }
 }
 }
 */
