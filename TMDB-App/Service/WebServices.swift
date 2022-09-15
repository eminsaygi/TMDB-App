//
//  WebServices.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

// MARK: - We used delegate to call from other classes
protocol WebServicesDelegate {
    func didUpdateMovies(movies: [Movie])
}

class WebServices {
    
    private let url = URL(string: "\(API.baseURL)&api_key=\(API.apiKey)")
    var delegate: WebServicesDelegate?
    
    // MARK: - URLSession
    func getDiscoverMovies() {
        
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
