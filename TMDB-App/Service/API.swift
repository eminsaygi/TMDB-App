//
//  API.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

class API {
     var baseURL: String {
        return "https://api.themoviedb.org"
    }
     var discoverURL: String {
        
        return "\(baseURL)/3/discover/movie?sort_by="
    }
    
     var imageURL: String {
        return "https://image.tmdb.org/t/p/w500"
    }
     var searchURL: String {
        
        return "\(baseURL)/3/search/movie?\(apiKey)&query="
    }
     var detailURL: String {

        return  " \(baseURL)/3/movie/"
    }
    
     let apiKey = "&api_key=464f8a5567ef6de84d256d195532ca13"
}

struct TypeMovie : Codable {
    static let voteCount = "vote_count.desc"
    static let popularity = "popularity.desc"
    static let upComing = "release_date.desc"
    
}
