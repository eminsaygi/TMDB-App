import Foundation

struct Movies: Codable {
    let page: Int?
    let results: [Movie]
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
