import Foundation
import UIKit
import Alamofire
import SwiftSpinner
import CPAlertViewController

class AddPlaceVC: UIViewController {
    @IBOutlet weak var spotName: UITextField!
    @IBOutlet weak var spotDescription: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
  
    @IBAction func saveButton(_ sender: Any) {
        let alert = CPAlertViewController()
        
        if spotName.text == "" {
            alert.showError(title: "Input a name".localized(), buttonTitle: "OK")
        }
        
        if spotDescription.text == "" {
            alert.showError(title: "Write a description".localized(), buttonTitle: "OK")
        }
        startDate.datePickerMode = UIDatePicker.Mode.date
        endDate.datePickerMode = UIDatePicker.Mode.date
        let date = DateFormatter()
        date.dateFormat = "dd MM yyyy"
        let startDateFormat = date.string(from: startDate.date)
        let endDateFormat = date.string(from: endDate.date)
        self.createSpotRequest(name: spotName.text!, description: spotDescription.text!, x_coordinate: 1, y_coordinate: 2,  initial_date: startDateFormat, end_date: endDateFormat)
    
    
    }
    
    

    
    

    func createSpotRequest(name:String, description:String, x_coordinate:Int, y_coordinate:Int, initial_date:String, end_date:String){
            let url = "http://localhost:8888/brightmaps/public/api/places"
            
            let parameters: Parameters = ["placeName": name, "description": description, "xCoordinate": x_coordinate, "yCoordinate": y_coordinate, "initialDate": initial_date, "endDate": end_date]

            
            let token = getDataInUserDefaults(key:"token")
            let alert = CPAlertViewController()
            let headers: HTTPHeaders = [
                "Authorization": token!,
                "Accept": "application/json"
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON{response in
                
                if (response.result.value != nil){
                    
                    var arrayResult = response.result.value as! Dictionary<String, Any>
                    switch response.result {
                    case .success:
                        switch arrayResult["code"] as! Int{
                        case 200:
                            
                        self.alertUser(alertTitle: "Spot saved!", alertMessage: "")
                            
                        default:
                            
                            print(arrayResult["message"] as! String)
                        }
                    case .failure:
                        
                        alert.showError(title: "Something went wrong".localized(), buttonTitle: "OK")
                    }
                }
            }
        }

        private func alertUser( alertTitle title: String, alertMessage  message: String )
        {
            let alert = UIAlertController(title: title, message: message,   preferredStyle: .alert)
            let actionTaken = UIAlertAction(title: "Ok", style: .default) { (hand) in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController
                self.present(destinationVC!, animated: true, completion: nil)
                
            }
            alert.addAction(actionTaken)
            self.present(alert, animated: true) {}
        }

}
