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
    //var result : Movie?
    // Asenkron olan işlem bittikten sonraki işlem için kullanılıyor.
    //Escaping closures
    // closures içerisinde foknsiyon içerisinde işlem bittikten sonra bir işlem yapmam gerekiyorsa escaping kullanmak gerekiyor.
    func getMovie(page:Int,completion: @escaping(Result<[Movie], Error>)->()){

        guard let url = URL(string: API.discoverURL+"&page=\(page)") else {return}
        
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
    
    func getMovieDetail(id: Int, completion: @escaping(Result<Movie, Error>)->()){
        guard let url = URL(string: "\(API.baseURL)/3/movie/\(id)?api_key=\(API.apiKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
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
}
