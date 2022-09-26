//
//  WebServices.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation
import UIKit


class WebServices {
    static let shared = WebServices()
    // MARK: - URLSession
    
    // Asenkron olan işlem bittikten sonraki işlem için kullanılıyor.
    //Escaping closures
    // closures içerisinde foknsiyon içerisinde işlem bittikten sonra bir işlem yapmam gerekiyorsa escaping kullanmak gerekiyor.
    func getMovie(completion: @escaping(Result<[Movie], Error>)->()){
        guard let url = URL(string: API.discoverURL) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(result.results))

            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func getMovVVieDetail(url: String, completion: @escaping(Result<Movie, Error>)->()){
        guard let searchURL = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(result))
            }
            catch {
             
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getSearchMovies(query: String, completion: @escaping(Result<[Movie], Error>)->()){
        guard let searchURL = URL(string: (API.searchURL) + (query)) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(result.results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

        
      
        
        /*
         static func getMovieDetail(with id: Int) {
         let searchURL = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=464f8a5567ef6de84d256d195532ca13&language=en-US")
         URLSession.shared.dataTask(with: searchURL!) {
         (data, response, error) in
         guard let safeData = data else { return}
         do {
         if error == nil {
         let jsonData =
         try JSONDecoder().decode(Movie.self, from: safeData)
         
         
         }
         } catch {
         print("Error")
         }
         }.resume()
         
         
         }
         */
        
        
        
        
    }
    // MARK: - We used delegate to call from other classes
    
    
    
    
    

