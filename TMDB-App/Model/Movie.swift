//
//  Movie.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

struct Movie: Codable {
    let id: Int?
    
    let overview,posterPath, releaseDate, title: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        
        case overview
        
        case posterPath = "poster_path"
        
        case releaseDate = "release_date"
        
        case title
        
    }
    
}
