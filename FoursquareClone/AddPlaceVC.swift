//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by cem bayat on 9.10.2021.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var plcNameTextField: UITextField!
    
    @IBOutlet weak var plcTypeTextField: UITextField!
    
    @IBOutlet weak var plcAtmosphereTextField: UITextField!
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        placeImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePicker))
        placeImageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    
    @objc func imagePicker() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func nextBtnClicked(_ sender: Any) {
        
        
        if plcNameTextField.text != "" && plcTypeTextField.text != "" && plcAtmosphereTextField.text != "" {
            if let chosenImage = placeImageView.image{
                
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = plcNameTextField.text!
                placeModel.placeType = plcTypeTextField.text!
                placeModel.placeAtmosphere = plcAtmosphereTextField.text!
                placeModel.placeImage = chosenImage
    
            }
            
            self.performSegue(withIdentifier: "toMapVC", sender: nil )
            
        } else {
            
            let alert = UIAlertController(title: "Error", message: "Gerekli Alanları Doldurunuz !", preferredStyle: UIAlertController.Style.alert)
            
            let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alert.addAction(okBtn)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
