import Foundation
import UIKit
import Alamofire
import SwiftSpinner
import CPAlertViewController

class SpotsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableSpots: UITableView!
    @IBOutlet weak var withoutResults: UILabel!
    
    
    func requestSpots(action: @escaping ()->(), notResults: @escaping ()->()){

        let url = "http://localhost:8888/brightmaps/public/api/places"
        
        
        let token = getDataInUserDefaults(key:"token")
        
        let headers: HTTPHeaders = [
            "Authorization": token!,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON{response in
            
            if (response.result.value != nil){

                
                var arrayResult = response.result.value as! Dictionary<String, Any>

                switch response.result {
                case .success:

                    
                    switch arrayResult["code"] as! Int{
                    case 200:
                        spots = arrayResult["data"] as! [[String:Any]]
                        
                        action()
                        
                    default:
                        notResults()
                        let alert = CPAlertViewController()
                        alert.showError(title: arrayResult["message"] as? String, buttonTitle: "OK")
                    }
                case .failure:
                    let alert = CPAlertViewController()
                    alert.showError(title: String(describing: response.error), buttonTitle: "OK")

                }
            }else{
                let alert = CPAlertViewController()
                alert.showError(title: "No se puede conectar al servidor", buttonTitle: "OK")
            }
        }
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaSpot", for: indexPath) as! SpotTableViewCell
        
        cell.spotName.text = spots[indexPath.row]["name"] as? String

        cell.initialDate.text = spots[indexPath.row]["initial_date"] as? String
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpotInfoVC") as! SpotInfoVC
//        globalidReceived = indexPath.row
//        vc.idReceived = globalidReceived!
//        vc.spotTitle = spots[indexPath.row]["name"] as! String
//        vc.start = spots[indexPath.row]["initial_date"] as! String
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let nav = segue.destination as! SpotInfoVC
        
        if let indexPath = tableSpots.indexPathForSelectedRow {
            nav.idReceived = indexPath.row
        }
        
    }
    func reloadTable(){
        tableSpots.reloadData()
        tableSpots.isHidden = false
        withoutResults.isHidden = true
    }
    
    
    func notResults(){
        withoutResults.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        withoutResults.isHidden = true

        
        requestSpots(action: {
            self.reloadTable()
        }, notResults: {
            self.notResults()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

        requestSpots(action: {
            self.reloadTable()
        }, notResults: {
            self.notResults()
        })

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}




