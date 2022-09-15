//
//  WebServices.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

protocol WebServicesDelegate {
    func didUpdateMovies(movies: [Movie])
}

class WebServices {
    
    var delegate: WebServicesDelegate?
    
    func fetchData() {
        
        let url = URL(string: "\(API.baseURL)&api_key=\(API.apiKey)")
        
        
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard let safeData = data else { return}
            do {
                if error == nil {
                    let jsonData =
                    try JSONDecoder().decode(MovieViewModel.self, from: safeData)
                    
                    self.delegate?.didUpdateMovies(movies: jsonData.results)
                    
                }
            } catch {
                print("Error")
            }
        }.resume()
        
        
    }
    
}
