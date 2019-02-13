import Foundation
import Alamofire
import UIKit
import SwiftSpinner
import CPAlertViewController


class SpotInfoVC: UIViewController{
    
    var idReceived: Int = 0
    
    @IBOutlet weak var spotName: UILabel!
    
    @IBOutlet weak var spotDescription: UITextView!
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
//    var spotTitle = ""
//    var spotInfo = ""
//    var start = ""
//    var end = ""
    
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        spotName.text = spotTitle
//        spotDescription.text = spotInfo
//        startDate.text = start
        
        
        let idCasted = (spots[idReceived]["id"] as! NSNumber).intValue
        requestSpot(id: idCasted) {
            
        }

        
        setInfoEvent()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let idCasted = (spots[idReceived]["id"] as! NSNumber).intValue
        requestSpot(id: idCasted) {
            
        }
    }
    
    func setInfoEvent(){
        spotName.text = spots[idReceived]["name"] as? String
        spotDescription.text = spots[idReceived]["description"] as? String
        startDate.text = spots[idReceived]["initial_date"] as? String
        endDate.text = spots[idReceived]["end_date"] as? String

    }
    

    
    func requestSpot(id:Int, action: @escaping () -> ()){
        let url = "http://localhost:8888/brightmaps/public/api/placeData"
        
        let parameters: Parameters = ["id":id]
        
        let token = getDataInUserDefaults(key:"token")
        
        let headers: HTTPHeaders = [
            "Authorization": token!,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON{response in
            
            if (response.result.value != nil){
                
                var arrayResult = response.result.value as! Dictionary<String, Any>
                
                
                switch response.result {
                case .success:
                    switch arrayResult["code"] as! Int{
                    case 200:
                        action()
                    default:
                        print(arrayResult["message"] as! String)
                    }
                case .failure:
                    
                    print("Error :: \(String(describing: response.error))")
                    //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
                }
            }
        }
    }

    
}
