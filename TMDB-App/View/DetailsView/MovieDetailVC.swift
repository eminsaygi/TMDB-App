import UIKit
import Kingfisher
import CoreData

class MovieDetailVC: UIViewController {
    
    var isactive : Bool = true
    var selectedId = 0
    
    private var urlString = ""
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveMovieButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        
       
        
    }
  
    // UIController başlamadan hemen önce çalışır.
    override func viewWillAppear(_ animated: Bool) {
        imageView.backgroundColor = .darkGray
        overViewLabel.text = ""
        
    }
    //UIController ekranı oluştuktan hemen sonra çalışır
    override func viewDidAppear(_ animated: Bool) {
        getDetailData()
        
    }
    // Core data veri kaydetme işlemini burada yapıyoruz.
    @IBAction func saveFavouriteButton(_ sender: Any) {
        
        
        do {
            if isactive == true {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let saveData = NSEntityDescription.insertNewObject(forEntityName: "MoviesData", into: context)
                print("Caks", appDelegate, "  ASA  ",context,"  ASA  ",saveData)
                saveData.setValue(titleLabel.text, forKey: "title")
                saveData.setValue(releaseLabel.text, forKey: "releaseDate")
                saveData.setValue(voteAverageLabel.text, forKey: "voteCount")
                
                saveData.setValue(urlString, forKey: "image")
                saveData.setValue(UUID(), forKey: "id")
                saveData.setValue(selectedId, forKey: "movieId")
                
                isactive = false
                print("catch Buraya veriyi kaydetti")
                try context.save() // Telefonu yeniden başlatınca kaydetmeyi sağlıyor
                savedAlert(title: "Succes", message: "Congratulations. Successfully Saved")
                isButtonImage(imageName: "checkmark.circle.fill")
                

            }
            else {
                isactive = true
                isButtonImage(imageName: "book")

                print("catch Buraya veriyiSildi")
                savedAlert(title: "Delete", message: "Congratulations. Successfully Deleted")
            }
        } catch {
            print("Catch: MovieDetailVC.swift : saveFavouriteButton")
            
        }
        
        // Kaydedilen bir data olduğu haberini gönderiyoruz. Bunu da newData key'i ile yapıyoruz.
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "newData"), object: nil)


    }
    func isButtonImage(imageName: String){
        
        saveMovieButton.setImage(UIImage(systemName: imageName), for: .normal)


    }
    
    // Kayıt başarılı olunca alert veriyor.
    func savedAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler:  nil)
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
}

// MARK: - Detay sayfası veri çekme işlemi

extension MovieDetailVC {
    
    func getDetailData(){
        WebServices.shared.getMovieDetail(id: selectedId){ result in
            
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.titleLabel.text = success.title
                    self.releaseLabel.text = success.releaseDate
                    self.overViewLabel.text = success.overview
                    let voteAveragaText = Utils.convertDouble(success.voteAverage, maxDecimals: 1)
                    self.voteAverageLabel.text = "\(voteAveragaText)/10"
                    
                    self.urlString = "\(API().imageURL)\(success.posterPath ?? "")"
                    let url = URL(string: self.urlString)
                    self.imageView.kf.setImage(with: url)
                    
                    
                }
            case.failure(_):
                print("Catch: MovieDetailVC.swift : getDetailData")
                
            }
        }
    }
}
