//
//  MoviesViewModel.swift
//  TMDB-App
//
//  Created by Emin Saygı on 25.09.2022.
//

import Foundation

// Oluşturduğunuz viewController kadar ViewModel olmalı
// table işlemleri ViewModel içerisinde yapılmaz.

struct MoviesTableViewModel {
    let movieList : [Movie]
    
    func numberOfRowsInSection() -> Int {
        return self.movieList.count
    }
    func moviesAtIndexPath(_ index: Int) -> MoviesViewModel {
        let movies = self.movieList[index]
        return MoviesViewModel(movies: movies)
    }
}

struct MoviesViewModel {
    let movies : Movie
    
    var title : String {
        return self.movies.title ?? ""
        
    }
    var relaseDate : String {
        return self.movies.releaseDate ?? ""
    }
    var overview : String {
        return self.movies.overview ?? ""
    }
}
