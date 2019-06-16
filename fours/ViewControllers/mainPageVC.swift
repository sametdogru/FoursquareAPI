//
//  ViewController.swift
//  fours
//
//  Created by MacBookPro on 11.06.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation

class mainPageVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var placeTypeView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    var places = [venuesModel]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        placeTypeText.text = "cafe"
        locationText.text = "istanbul"
        
        self.placeTypeText.delegate = self
        radius()
    }

    func radius() {
       placeTypeView.layer.cornerRadius = 7
       locationView.layer.cornerRadius = 7
       searchView.layer.cornerRadius = 5
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if placeTypeText.text != "" && locationText.text != "" {
            if placeTypeText.text!.count >= 3 {
                 getListOfVenues()
            } else {
                let alert = UIAlertController(title: "Error", message: "En az 3 karakterli yer adı giriniz.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Yer adı giriniz.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getListOfVenues() {
        
        self.places.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        var urlPrefix :String = "https://api.foursquare.com/v2/venues/search?near="+locationText.text!
        var urlSuffix :String = "&query="+placeTypeText.text!+"&client_id=\(clientID)&client_secret=\(clientSecret)&v=20190520"
        var url :String = urlPrefix + urlSuffix
        
        AF.request(url).responseJSON { response in
            print(response)
            if let json = response.value {
                
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let venuesArray = responseModel["venues"] as! NSArray;
                
                for object in venuesArray {
                    print("object")
                    let venue = object as! NSDictionary;
                    let location = venue["location"] as! NSDictionary;
                    let categoriArray = venue["categories"] as! NSArray;
                    
                    var id: String = ""
                    var name: String = ""
                    var adress: String = ""
                    var city: String = ""
                    var country: String = ""
                    var photo: String = ""
                    var latitude: Double = 0
                    var longitude: Double = 0
                    
                    if venue["id"] != nil {
                        id = (venue["id"] as! String)
                    }
                    if venue["name"] != nil {
                        name = (venue["name"] as! String)
                    }
                    if location["address"] != nil {
                        adress = (location["address"] as! String)
                    }
                    if location["city"] != nil {
                        city = (location["city"] as! String)
                    }
                    if location["country"] != nil {
                        country = (location["country"] as! String)
                    }
                    if location["lat"] != nil {
                        latitude = (location["lat"] as! Double)
                    }
                    if location["lng"] != nil {
                        longitude = (location["lng"] as! Double)
                    }
                    
                    for categori in categoriArray {
                        let model = categori as! NSDictionary;
                        let icon = model["icon"] as! NSDictionary;
                        photo = (icon["prefix"] as! String) + (icon["suffix"] as! String)
                    }
                    
                    let mekan = venuesModel(id: id, name: name, adress: adress, city: city, country: country, photo: photo, lat: latitude, lng: longitude)
                    
                    self.places.append(mekan);
                    
                }
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "mainPageVCToPlacesVC", sender: nil)
                }
              MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainPageVCToPlacesVC" {
            let vc = segue.destination as! placesVC
            vc.mekanArray = places
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

