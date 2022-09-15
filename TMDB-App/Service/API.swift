//
//  API.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

class API: NSObject {
    static var baseURL: String {
         
        return "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc"
    }
    
    static var evaluatorURL: String {
        return "api.themoviedb.org"
    }
    static let apiKey = "464f8a5567ef6de84d256d195532ca13"
}

