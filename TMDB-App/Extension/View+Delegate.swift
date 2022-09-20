//
//  View+Delegate.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation
import UIKit

// MARK: - We added additional features to the Web Services Delegate protocol running on the ViewController
extension ViewController: WebServicesDelegate {
    func didUpdateMovies(movies: [Movie]) {
        self.movieModel = movies
        DispatchQueue.main.async {
            
            self.movieTable.refreshControl?.endRefreshing()
            self.movieTable.reloadData()
            
        }
    }
}




