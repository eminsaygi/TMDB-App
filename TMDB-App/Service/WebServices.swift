//
//  WebServices.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation
import UIKit



final class WebServices {
     

    static let url = URL(string: "\(API.baseURL)&api_key=\(API.apiKey)")
    static var delegate: WebServicesDelegate?
    
    // MARK: - URLSession
    static func getDiscoverMovies() {
        
        
        
        URLSession.shared.dataTask(with: url!) {
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
     
    static func getDiscoverSearchMovies(with text: String) {
         let url2 = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=464f8a5567ef6de84d256d195532ca13&query=\(text)")
        URLSession.shared.dataTask(with: url2!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(MovieViewModel.self, from: safeData)
                   // print(jsonData)
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
