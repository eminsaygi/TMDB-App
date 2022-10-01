//
//  DropDown.swift
//  TMDB-App
//
//  Created by Emin Saygı on 30.09.2022.
//

import Foundation

extension MovieListVC {
    
    
    func DropDownListOptions() {
        
        lblTitle.text = "Top Rated"
        
        dropDown.anchorView = viewDropDown
        dropDown.dataSource = categoryMovies
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch item {
            case "Top Rated":
                getMovieData(type: TypeMovie.voteCount)
            case "Most Popular":
                getMovieData(type: TypeMovie.popularity)
            case "Latest":
                getMovieData(type: TypeMovie.upComing)
            default:
                getMovieData(type: TypeMovie.voteCount)

            }
          self.lblTitle.text = categoryMovies[index]

        }
        dropDown.willShowAction = { [unowned self] in
            moviesData.removeAll()

        }
        
    }
}
