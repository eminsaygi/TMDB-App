import Foundation
import UIKit


class WebServices {
    static let shared = WebServices()
    private var api = API()
    private var session = URLSession.shared
    
    // Asenkron işlemler için escaping clousere kullandık. Modeli işledikten sonra tekrar çağırmamız gerektiği için completion tamamlama bloğu içerisinde escaping clousere kullandık
    func getMovie(page:Int, type: String, completion: @escaping(Result<[Movie], Error>)->()){
        
        guard let url = URL(string: api.discoverURL + "\(type)" + API().apiKey+"&page=\(page)") else {return}
        
        session.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(result.results!))
            }
            catch {
                completion(.failure(error))
                print("Catch: WebServices.swift : getMovie")
                
            }
        }
        .resume()
    }
    
    func getMovieDetail(id: Int, completion: @escaping(Result<Movie, Error>)->()){
        guard let url = URL(string: "\(api.baseURL)/3/movie/\(id)?\(API().apiKey)&language=en-US") else {return}
        let task = session.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(result))
            }
            catch {
                
                completion(.failure(error))
                print("Catch: WebServices.swift : getMovieDetail")
                
            }
        }
        task.resume()
    }
    
    func getSearchMovies(query: String, completion: @escaping(Result<[Movie], Error>)->()){
        guard let searchURL = URL(string: api.searchURL + (query)) else {return}
        let task = session.dataTask(with: URLRequest(url: searchURL)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(result.results!))
            }
            catch {
                completion(.failure(error))
                print("Catch: WebServices.swift : getSearchMovies")
                
            }
        }
        task.resume()
    }
    
    func fetchRequestToken(completion: @escaping (RequestToken) -> Void) {
        guard let url = URL(string: "\(API().baseURL)/3/authentication/token/new?api_key=464f8a5567ef6de84d256d195532ca13") else {return}
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let requestToken = try decoder.decode(RequestToken.self, from: data)
                    completion(requestToken)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    func login(token:String,userName: String, password: String,completion: @escaping (RequestToken) -> Void) {
        guard let url = URL(string: "\(API().baseURL)/3/authentication/token/validate_with_login?api_key=464f8a5567ef6de84d256d195532ca13&username=\(userName)&password=\(password)&request_token=\(token)") else {return
            
            
        }
        print(url)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let requestToken = try decoder.decode(RequestToken.self, from: data)
                    completion(requestToken)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
 
    
}
