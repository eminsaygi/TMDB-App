//
//  API.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

class API: NSObject {
    static var baseURL: String {
        return "https://api.themoviedb.org"
    }
    static var discoverURL: String {
        
        return "\(baseURL)/3/discover/movie?sort_by=vote_count.desc&api_key=\(apiKey)"
    }
    
    static var imageURL: String {
        return "https://image.tmdb.org/t/p/w500"
    }
    static var searchURL: String {
        
        return "\(baseURL)/3/search/movie?api_key=\(apiKey)&query="
    }
    
    static let apiKey = "464f8a5567ef6de84d256d195532ca13"
}

