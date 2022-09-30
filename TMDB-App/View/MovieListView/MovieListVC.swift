//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import DropDown
class MovieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    var moviesData: [Movie] = [Movie]()
    
    var currentPage: Int = 1
    var selectedId = 0
    
    @IBOutlet weak var movieTable: UITableView!
    @IBOutlet weak var vwDropDown: UIView!
    
    let dropDown = DropDown()
    let fruitsArray = ["Top Rated","Most Popular","Latest"]

    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad()  {
        super.viewDidLoad()
        lblTitle.text = "Top Rated"
        dropDown.anchorView = vwDropDown
        dropDown.dataSource = fruitsArray
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            switch item {
            case "Top Rated":
                fetchMoviePopData()
            case "Most Popular":
                fetchMovieData()
            case "Latest":
                fetchMovieLatestData()
            default:
                fetchMovieData()
            }
            if item == "banana" {
                print("BURAYA GELDİ", currentPage)
            }
            
          self.lblTitle.text = fruitsArray[index]

        }
        dropDown.willShowAction = { [unowned self] in
          print("Drop down will show")
            moviesData.removeAll()

        }
        
        //dropDown.dismissMode = .automatic

        
        
        
        movieTable.delegate = self
        movieTable.dataSource = self
        searchController()
        fetchMovieData()
        
    }
    func fetchMoviePopData(){
        WebServices.shared.getMovie(page: currentPage, type: TypeMovie.popularity) {  result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.moviesData.append(contentsOf: data)
                    self.movieTable.reloadData()
                    self.currentPage += 1
                    
                    
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    func fetchMovieLatestData(){
        WebServices.shared.getMovie(page: currentPage, type: TypeMovie.upComing) {  result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.moviesData.append(contentsOf: data)
                    self.movieTable.reloadData()
                   // self.currentPage += 1
                    
                    
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func fetchMovieData(){
        WebServices.shared.getMovie(page: currentPage, type: TypeMovie.voteCount) {  result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.moviesData.append(contentsOf: data)
                    self.movieTable.reloadData()
                    self.currentPage += 1
                    
                    
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //print("Pagee: ", indexPath.row)
        cell.movieDataFetch(movie: (moviesData[indexPath.row]))
        
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = moviesData[indexPath.row].id ?? 0
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            
            detailVC?.selectedId = selectedId
            
            
        }
    }
    
    
    @IBAction func showCategoryOptions(_ sender: Any) {
        dropDown.show()
    }
    
    
    
}

// İnfinite scroll
extension MovieListVC: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row  >= moviesData.count - 1{
                fetchMovieData()
                print("Page-----------------------")

                print("PageIndexPath: ", indexPaths)
                print("PageIndex", index)
                print("PageIndexRow", index.row)
                print("PageMoviesDataCount",moviesData.count)
                print("PageCurrentPage:" , currentPage)
                
                
            }
        }
    }
}






