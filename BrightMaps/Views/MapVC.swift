import MapKit
import CoreLocation
import Alamofire
import Foundation
import UIKit
import SwiftSpinner
import CPAlertViewController



class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mkMap: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    var longX: Float = 0.0
    var latY: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mkMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        requestSpots()
    }
    
    
    func requestSpots(){
        
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
                        

                        
                        
                        for item in spots{
                            self.longX =  (item["x_coordinate"] as! NSNumber).floatValue
                            self.latY = (item["y_coordinate"] as! NSNumber).floatValue
                            self.addMarkers(latitude: self.latY , longitude: self.longX)
                        }
                        

                        
                    default:

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

    private func addMarkers(latitude: Float, longitude: Float) {

        let spotMarker = placeAnnotation()
        spotMarker.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) , longitude: CLLocationDegrees(longitude))


        mkMap.addAnnotation(spotMarker)


    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let annotation = annotation as? placeAnnotation else {
            return nil
        }
        
        let marker = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        
        marker.canShowCallout = true
        
        marker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        let markerImage = UIImage(named: "spot")
        
        marker.image = markerImage
        
        return marker
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        clearUserDefaults()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
        }
    
    
    class placeAnnotation : MKPointAnnotation {
        var id: String?
    }


}

