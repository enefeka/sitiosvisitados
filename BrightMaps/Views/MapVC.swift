//import MapKit
//import CoreLocation
//import Alamofire
//import Foundation
//import UIKit
//import SwiftSpinner
//import CPAlertViewController
//
//
//class MapVC: UIViewController, CLLocationManager, UITextFieldDelegate{
//    
//    var adress = ""
//    
//    var locationManager = CLLocationManager()
//    var previousLocation: CLLocation?
//    let geocoder = CLGeocoder()
//    
//    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//    let annotation = MKPointAnnotation()
//    
//    var position = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        requestSpots()
//
//
//    }
//    
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
// 
//        requestSpots()
//        insertPines()
//        
//    }
//    
//    func requestSpots(){
//        
//        let url = "http://localhost:8888/brightmaps/public/api/places"
//        
//        
//        let token = getDataInUserDefaults(key:"token")
//        
//        let headers: HTTPHeaders = [
//            "Authorization": token!,
//            "Accept": "application/json"
//        ]
//        
//        Alamofire.request(url, method: .get, headers: headers).responseJSON{response in
//            
//            if (response.result.value != nil){
//                
//                
//                var arrayResult = response.result.value as! Dictionary<String, Any>
//                
//                switch response.result {
//                case .success:
//                    
//                    
//                    switch arrayResult["code"] as! Int{
//                    case 200:
//                        spots = arrayResult["data"] as! [[String:Any]]
//                        
//
//                        
//                    default:
//
//                        let alert = CPAlertViewController()
//                        alert.showError(title: arrayResult["message"] as? String, buttonTitle: "OK")
//                    }
//                case .failure:
//                    let alert = CPAlertViewController()
//                    alert.showError(title: String(describing: response.error), buttonTitle: "OK")
//                    
//                }
//            }else{
//                let alert = CPAlertViewController()
//                alert.showError(title: "No se puede conectar al servidor", buttonTitle: "OK")
//            }
//        }
//    }
//    
//}
