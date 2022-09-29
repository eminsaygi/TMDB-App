//
//  API.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

class API: NSObject {
     var baseURL: String {
        return "https://api.themoviedb.org"
    }
     var discoverURL: String {
        
        return "\(baseURL)/3/discover/movie?sort_by=vote_count.desc&api_key=\(apiKey)"
    }
    
     var imageURL: String {
        return "https://image.tmdb.org/t/p/w500"
    }
     var searchURL: String {
        
        return "\(baseURL)/3/search/movie?api_key=\(apiKey)&query="
    }
     var detailURL: String {

        return  " \(baseURL)/3/movie/"
    }
    
     let apiKey = "464f8a5567ef6de84d256d195532ca13"
}

