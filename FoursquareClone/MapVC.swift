//
//  MapVC.swift
//  FoursquareClone
//
//  Created by cem bayat on 9.10.2021.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveBtnClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.done, target: self, action: #selector(backBtnClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    

    @objc func saveBtnClicked() {
        // Parse save işlemleri
        
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
            
        }
        
        object.saveInBackground { success, error in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
            
        }
        
    }
    
    @objc func backBtnClicked() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
        }
        
    }
    
    

}
