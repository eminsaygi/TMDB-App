//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import DropDown
import CoreData

class MovieListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    var nameArray = [String]()
    var idArray = [UUID]()
    
    
    
    var moviesData: [Movie] = [Movie]()
    let dropDown = DropDown()
    
    var currentPage: Int = 1
    var selectedId = 0
    let categoryMovies = ["Top Rated","Most Popular","Latest"]
    
    
    @IBOutlet weak var movieTable: UITableView!
    @IBOutlet weak var viewDropDown: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
    
        
        movieTable.delegate = self
        movieTable.dataSource = self
        
        searchController()
        getMovieData(type: TypeMovie.voteCount)
        DropDownListOptions()
        
    }
    
     
    func getData(){
        guard let appDelagate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
           let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
            }
        } catch {
            
        }
        
    }
    
    
    @objc func addItem(){
        performSegue(withIdentifier: "toFavoriteCV" , sender: nil)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
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
        currentPage = 1
    }
    
    func getMovieData(type: String) {
        WebServices.shared.getMovie(page: currentPage, type: type) {  result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.moviesData.append(contentsOf: data)
                    self.movieTable.reloadData()
                    self.currentPage += 1
                    
                    
                }
                
            case.failure(let error):
                print("Catch: ",error)
            }
        }
    }
    
  
    
}



// İnfinite scroll
extension MovieListVC: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row  >= moviesData.count - 1{
                
                
                let categoryControl = self.lblTitle.text
                switch categoryControl {
                case "Top Rated":
                    getMovieData(type: TypeMovie.voteCount)
                case "Most Popular":
                    getMovieData(type: TypeMovie.popularity)
                case "Latest":
                    getMovieData(type: TypeMovie.upComing)
                default:
                    getMovieData(type: TypeMovie.voteCount)
                }
            }
        }
    }
}





