import Foundation

struct Movies: Decodable {
    let page: Int?
    let results: [Movie]?
}

//Decodable protocolünü kullanma amacımız; Json türündeki bir datayı Swfit dili için uygun objeleri çevirmemizi sağlıyor.
struct Movie: Decodable {
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
