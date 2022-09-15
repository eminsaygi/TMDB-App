//
//  ViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 15.09.2022.
//

import UIKit
import Kingfisher
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var dataModel = [Movie]()
    var webService = WebServices()

    
    @IBOutlet weak var myTable: UITableView!
    
    
    private var movieTableViewModel : TableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        
        webService.delegate = self
        webService.fetchData()
       // webService.AlomofireFetch()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.dataFetch(movie: dataModel[indexPath.row])
        
        let url = URL(string: "\(API.imageURL)\(dataModel[indexPath.row].poster_path)")
        DispatchQueue.main.async {
            cell.movieImage.kf.setImage(with: url)
        }
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details: DetailsViewController = self.storyboard?.instantiateViewController(identifier: "DetailsViewController") as!DetailsViewController
            navigationController?.pushViewController(details, animated: true)
        

        let url = URL(string: "\(API.imageURL)\(dataModel[indexPath.row].poster_path)")

        DispatchQueue.main.async {
            details.imageView.kf.setImage(with: url)
        }
            DispatchQueue.main.async {
                details.releaseLabel.text = Utils.formattedDateFromString(dateString: self.dataModel[indexPath.row].release_date, withFormat: "dd.MM.yyyy")
                details.titleLabel.text = self.dataModel[indexPath.row].title
                details.overViewTextFiled.text = self.dataModel[indexPath.row].overview

            }

    }

}
