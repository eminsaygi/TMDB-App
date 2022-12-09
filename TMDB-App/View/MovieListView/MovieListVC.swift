import UIKit
import DropDown
import CoreData

class MovieListVC: UIViewController, UISearchResultsUpdating {
    private var moviesData: [Movie] = [Movie]()
    private let dropDown = DropDown()
    private let typeMovie = TypeMovie()
    private var currentPage: Int = 1
    private var selectedId = 0
    private var movieIdArray = [Int]()
    public var langString = ""
    
    
    
    @IBOutlet weak private var movieTable: UITableView!
    @IBOutlet weak private var viewDropDown: UIView!
    @IBOutlet weak private var lblTitle: UILabel!
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieTable.dataSource = self
        
        refreshControl()
        
        
        
    }
    
    
    private func getCoreData(){
        //Aynı türden verileri kaydetmemeyi sağlıyor.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        fetchRequest.returnsObjectsAsFaults = false // Büyük data verilerini okurken hız sağlıyor.
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if let movieId = result.value(forKey: "movieId") as? Int {
                        movieIdArray.append(movieId)
                        
                    }
                    
                }
            }
            
        } catch {
            print("Catch: MovieListVC.swift : getCoreData")
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        DropDownListOptions()
        searchController()



        
    }
    
    // View ekranı oluştuktan hemen sonra çağrılır.
    override func viewDidAppear(_ animated: Bool) {
        getMovieData(type: typeMovie.voteCount)
        
    }
    
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            detailVC?.selectedId = selectedId
            detailVC?.movieIdArray = movieIdArray
            
            
        }
    }
    
    
    
}

extension MovieListVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MovieListTableViewCell = movieTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieListTableViewCell
        
        
        cell.movieDataFetch(movie: (moviesData[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = moviesData[indexPath.row].id ?? 0
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toDetailVC", sender: nil)
            
        }
    }
    
    
}




//MARK: - Film verilerini çekme işlemi
extension MovieListVC {
    
    func getMovieData(type: String) {
        WebServices.shared.getMovie(page: currentPage, type: type) {  result in
            
            switch result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    self.moviesData.append(contentsOf: data)
                    self.movieTable.reloadData()
                    //self.currentPage += 1
                    
                    
                }
                
            case.failure(_):
                print("Catch: MovieListVC.swift : getMovieData")
            }
        }
    }
}



//MARK: - TableView sonsuz scrool işlemi
// TableView dataları gelmeden arka planda bunların countunu alıp işlem yapmamızı sağlıyor.
extension MovieListVC: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            // -1 koyulması sebebi; oluşturulan diziler arasında sonsuz döngüye girmesini sağlıyor.
            if index.row  >= moviesData.count - 1{
                let categoryControl = self.lblTitle.text
                switch categoryControl {
                case "\(langChange(str: "Top Rated", lang: Utils.shared.lang))":
                    getMovieData(type: typeMovie.voteCount)
                case "\(langChange(str: "Most Popular", lang: Utils.shared.lang))":
                    getMovieData(type: typeMovie.popularity)
                case "\(langChange(str: "Latest", lang: Utils.shared.lang))":
                    getMovieData(type: typeMovie.upComing)
                default:
                    getMovieData(type: typeMovie.voteCount)
                }
            }
        }
    }
}


//MARK: - Açılır kategori işlemleri
extension MovieListVC {
    
    
    private func DropDownListOptions() {
        let categoryMovies = ["\(langChange(str: "Top Rated", lang: Utils.shared.lang))","\(langChange(str: "Most Popular", lang: Utils.shared.lang))","\(langChange(str: "Latest", lang: Utils.shared.lang))"]
        
        lblTitle.text = "\(langChange(str: "Top Rated", lang: Utils.shared.lang))"
        
        dropDown.anchorView = viewDropDown
        dropDown.dataSource = categoryMovies
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch item {
            case "\(langChange(str: "Top Rated", lang: Utils.shared.lang))":
                getMovieData(type: typeMovie.voteCount)
            case "\(langChange(str: "Most Popular", lang: Utils.shared.lang))":
                getMovieData(type: typeMovie.popularity)
            case "\(langChange(str: "Latest", lang: Utils.shared.lang))":
                getMovieData(type: typeMovie.upComing)
            default:
                getMovieData(type: typeMovie.voteCount)
                
            }
            self.lblTitle.text = categoryMovies[index]
            
        }
        dropDown.willShowAction = { [unowned self] in
            moviesData.removeAll()
            
        }
        
    }
    @IBAction func showCategoryOptions(_ sender: Any) {
        dropDown.show()
        currentPage = 1
    }
}

//MARK: - Arama işlemleri

extension MovieListVC{
    
    private func searchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = langChange(str: "Type something here to search movies", lang: Utils.shared.lang)
        navigationItem.searchController = search
        
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            let query = Utils.searchStringEdited(query: text)
            WebServices.shared.getSearchMovies(query: query) { [weak self] result in
                
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        
                        self!.moviesData = success
                        self!.movieTable.reloadData()
                        
                    }
                    
                case.failure(_):
                    print("Catch: MovieListVC.swift : updateSearchResults")
                }
            }
        }
    }
    
}

//MARK: - Refresh Control Section

extension MovieListVC{
    
    func refreshControl(){
        movieTable.refreshControl = UIRefreshControl()
        movieTable.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    
    @objc private func didPullToRefresh(){
        moviesData.removeAll()
        currentPage = 1
        getMovieData(type: typeMovie.voteCount)
        lblTitle.text = "\(langChange(str: "Top Rated", lang: Utils.shared.lang))"
        movieTable.refreshControl?.endRefreshing()
    }
    
}
