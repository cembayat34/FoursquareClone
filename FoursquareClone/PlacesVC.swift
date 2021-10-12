//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by cem bayat on 8.10.2021.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBtnClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutBtnClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
        
    }
    
    
    func getDataFromParse() {
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            } else {
                
                if objects != nil {
                    
                    self.placeIdArray.removeAll()
                    self.placeNameArray.removeAll()
                    
                    for object in objects! {
                        
                        if let placeName =  object.object(forKey: "name") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
                
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC" {
            
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = selectedPlaceId
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    

    @objc func addBtnClicked(){
        
        // segue
        
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
    }
    
    @objc func logoutBtnClicked(){
        
        PFUser.logOutInBackground { error in
            
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            } else {
                
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    
    func makeAlert(title : String, message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okBtn)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
