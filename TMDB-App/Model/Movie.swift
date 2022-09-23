//
//  Movie.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

struct Movies: Codable {
    let page: Int?
    var results: [Movie]?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        
    }
    
    
}


struct Movie: Codable {
    let id: Int?
    let voteAverage: Double
    
    let overview,posterPath, releaseDate, title: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        
        case overview
        
        case posterPath = "poster_path"
        
        case releaseDate = "release_date"
        
        case title
        
        case voteAverage = "vote_average"
        
    }
    
}
