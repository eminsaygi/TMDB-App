//
//  View+Delegate.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import Foundation
import UIKit


extension ViewController: WebServicesDelegate {
    func didUpdateMovies(movies: [Movie]) {
        self.dataModel = movies
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
    }
}




