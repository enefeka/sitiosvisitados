import Foundation
import UIKit
import Alamofire
import SwiftSpinner
import CPAlertViewController


class RecoverVC: UIViewController{
    
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func recoverPw(_ sender: Any)  {
        
        let alert = CPAlertViewController()
        
        
        if emailText.text != ""{
            
            if isValidEmail(YourEMailAddress: emailText.text!) {
                
                self.recoverRequest(email: emailText.text!)
                        

                
            }else {
                alert.showError(title: "Email Incorrecto".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "Introduzca un email".localized(), buttonTitle: "OK")
        }
    }
    
    func recoverRequest(email:String){
        
        
        let url = "http://localhost:8888/brightmaps/public/api/recover"
        
        let parameters : Parameters = ["email":email]
        
        SwiftSpinner.show("...")
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{response in
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    self.alertUser(alertTitle: "Contraseña enviada", alertMessage: "")
                    break
                    
                default:
                    
                    SwiftSpinner.hide()
                    alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
            }
            
            
        }
    }
    
    private func alertUser( alertTitle title: String, alertMessage  message: String )
    {
        let alert = UIAlertController(title: title, message: message,   preferredStyle: .alert)
        let actionTaken = UIAlertAction(title: "Ok", style: .default) { (hand) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? SignInVc
            self.present(destinationVC!, animated: true, completion: nil)
            
        }
        alert.addAction(actionTaken)
        self.present(alert, animated: true) {}
    }
    
}
