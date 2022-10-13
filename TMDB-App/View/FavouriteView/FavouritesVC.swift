import UIKit
import CoreData
import Kingfisher

class FavouritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Core data içerisine kaydedilecek veri dizileri
    private var titleArray = [String]()
    private var movieIdArray = [Int]()
    private var relaseDateArray = [String]()
    private var movieImageData = [String]()
    private var voteAverageArray = [String]()
    private var idArray = [UUID]()
    
    private var selectedId = 0
    
    private var moviesData: [Movie] = [Movie]()
    
    
    
    
    @IBOutlet weak var favouritesTable: UITableView!
    
    // 1 defa çalışır. IBOutletleri hazır hale geitirir.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesTable.delegate = self
        favouritesTable.dataSource = self
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    //UI Ekranı başlamadan hemen önce çağrılır.
    override func viewWillAppear(_ animated: Bool) {
        // Bir gözlemci tanımladık. Haberciden gelecek verileri işleyecek.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FavouriteCell = favouritesTable.dequeueReusableCell(withIdentifier: "favouritesCell", for: indexPath) as! FavouriteCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.relaseLabel.text = relaseDateArray[indexPath.row]
        cell.voteAverageLabel.text = voteAverageArray[indexPath.row]
        let url = URL(string: movieImageData[indexPath.row])
        cell.movieImageView.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = movieIdArray[indexPath.row]
        performSegue(withIdentifier: "toFavDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavDetailVC"  {
            let detailVC = segue.destination as? MovieDetailVC
            
            detailVC?.selectedId = selectedId
            
            
        }
    }
    
    
    
    
}
// MARK: - TableView'da seçilen satıları silme işlemi
extension FavouritesVC {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        let idString = idArray[indexPath.row].uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        
        fetchRequest.returnsObjectsAsFaults = false // Büyük data verilerini okurken hız sağlıyor.
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "id") as? UUID {
                    context.delete(result)
                    
                    idArray.remove(at: indexPath.row)
                    movieIdArray.remove(at: indexPath.row)
                    titleArray.remove(at: indexPath.row)
                    movieImageData.remove(at: indexPath.row)
                    relaseDateArray.remove(at: indexPath.row)
                    voteAverageArray.remove(at: indexPath.row)
                    
                    self.favouritesTable.reloadData()
                    
                    do  {
                        try context.save()
                    } catch {
                        print("Catch: FavouritesVC.swift : NSManagedObject")
                    }
                }
            }
        } catch {
            print("Catch: FavouritesVC.swift : commit editingStyle")
            
        }
    }
}

//MARK: - CoreData üzerinden gelen verileri çekme
extension FavouritesVC {
    
    @objc private func getData(){
        //Aynı türden verileri kaydetmemeyi sağlıyor.
        self.titleArray.removeAll(keepingCapacity: true)
        self.idArray.removeAll(keepingCapacity: true)
        self.movieIdArray.removeAll(keepingCapacity: true)
        self.movieImageData.removeAll(keepingCapacity: true)
        self.voteAverageArray.removeAll(keepingCapacity: true)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        fetchRequest.returnsObjectsAsFaults = false // Büyük data verilerini okurken hız sağlıyor.
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                
                if let title = result.value(forKey: "title") as? String {
                    self.titleArray.append(title)
                    
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                    
                }
                
                if let movieId = result.value(forKey: "movieId") as? Int {
                    self.movieIdArray.append(movieId)
                    
                    
                }
                if let relaseDate = result.value(forKey: "releaseDate") as? String {
                    self.relaseDateArray.append(relaseDate)
                    
                }
                if let movieImage = result.value(forKey: "image") as? String {
                    self.movieImageData.append(movieImage)
                    
                }
                
                if let voteAverage = result.value(forKey: "voteCount") as? String {
                    
                    self.voteAverageArray.append(voteAverage)
                    
                }
                
                
                self.favouritesTable.reloadData()
            }
        } catch {
            print("Catch: FavouritesVC.swift : DataList")
            
        }
    }
}


