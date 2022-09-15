//
//  Movie.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation

struct Movie: Codable{
    let title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let id: Int

}
