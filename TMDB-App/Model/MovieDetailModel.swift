//
//  MovieDetailModel.swift
//  TMDB-App
//
//  Created by Emin Saygı on 27.09.2022.
//

import Foundation

struct MovieDetailModel: Codable {
    let id: Int?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case  id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
