//
//  FavouritesVC.swift
//  TMDB-App
//
//  Created by Emin Saygı on 1.10.2022.
//

import UIKit
import CoreData

class FavouritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var titleArray = [String]()
    var idArray = [UUID]()
    
    
    
   
    
    
    @IBOutlet weak var favouritesTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesTable.delegate = self
        favouritesTable.dataSource = self
        
        getData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FavouriteCell = favouritesTable.dequeueReusableCell(withIdentifier: "favouritesCell", for: indexPath) as! FavouriteCell
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.relaseLabel.text = "Saygı"
        cell.voteAverageLabel.text = "9/10"
        //let cell = UITableViewCell()
        //cell.textLabel?.text = "Selam Emin"
        return cell
    }
    
    @objc func getData(){
        self.titleArray.removeAll(keepingCapacity: true)
        self.idArray.removeAll(keepingCapacity: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        fetchRequest.returnsObjectsAsFaults = false // Büyük data verilerini okurken hız sağlıyor.
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as!  [NSManagedObject]{
                if let title = result.value(forKey: "title") as? String {
                    self.titleArray.append(title)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.favouritesTable.reloadData()
            }
        } catch {
            
        }
    }
    
}

    
    /*
     @IBAction func savedButton(_ sender: Any) {
     
     //Veri Kaydetme
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let saveData = NSEntityDescription.insertNewObject(forEntityName: "MoviesData", into: context)
     
     saveData.setValue(titleLabel.text, forKey: "title")
     
     //if let voteA = Double(voteAverageLabel.text!) {
     //  saveData.setValue(voteA, forKey: "voteAverage")
     //}
     // saveData.setValue(voteAverageLabel.text, forKey: "voteAverage")
     // saveData.setValue(relaseLabel.text, forKey: "relaseLabel")
     
     let imagePress = movieImage.image?.jpegData(compressionQuality: 0.5)
     saveData.setValue(imagePress, forKey: "image")
     
     saveData.setValue(UUID(), forKey: "id")
     
     do {
     try context.save()
     print("succes")
     
     } catch {
     print("Kaydetme atası")
     }
     
     
     }
     
     */
    
