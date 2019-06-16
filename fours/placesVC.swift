//
//  placesVC.swift
//  fours
//
//  Created by MacBookPro on 11.06.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import FoursquareAPIClient
import SDWebImage
import MapKit
import CoreLocation

class placesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate,CLLocationManagerDelegate{
   
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var lblComment: UILabel!

    @IBOutlet var placeView: UIView!
    
    var manager = CLLocationManager()
    var requestCLLocation = CLLocation()
    
    var choosePlace: venuesModel? = nil
    var mekanArray: [venuesModel] = []
    var tipsList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "VenueCell")
        
        viewPopUp.isHidden = true
        viewPopUp.layer.cornerRadius = 10
        viewPopUp.layer.shadowColor = UIColor.black.cgColor
        viewPopUp.layer.shadowRadius = 8.0
        viewPopUp.layer.shadowOpacity = 0.7
        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mekanArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = listTableView.dequeueReusableCell(withIdentifier: "VenuesCell", for: indexPath) as! venuesTableViewCell
        cell.venuesName.text = mekanArray[indexPath.row].name
        cell.venuesAdress.text = mekanArray[indexPath.row].adress
        cell.venuesCity.text = mekanArray[indexPath.row].city
        cell.venuesCountry.text = mekanArray[indexPath.row].country

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "fromPlacesVCtodetailsVC", sender: indexPath.row)
        viewPopUp.isHidden =  false
        self.choosePlace = mekanArray[indexPath.row]
        nameLabel.text = choosePlace?.name
        getPhotosOfVenues()
    }
    
    func getPhotosOfVenues() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        let url : String = "https://api.foursquare.com/v2/venues/"+choosePlace!.id+"/photos?client_id=\(clientID)&client_secret=\(clientSecret)&v=20190521"
        AF.request(url).responseJSON { response in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let photoModel = responseModel["photos"] as! NSDictionary;
                let photoItemsArray = photoModel["items"] as! NSArray;
                var photo = ""
                let object = photoItemsArray[0]
                let model = object as! NSDictionary;
                photo = (model["prefix"] as! String) + "414x268"+(model["suffix"] as! String)
                self.imageView.sd_setImage(with: URL(string:photo))
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.getListOfTips()
        }
    }
    
    func getListOfTips() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        let url : String = "https://api.foursquare.com/v2/venues/"+choosePlace!.id+"/tips?client_id=\(clientID)&client_secret=\(clientSecret)&v=20190521"
        print(url)
        AF.request(url).responseJSON { response in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let tipsModel = responseModel["tips"] as! NSDictionary;
                let tipsItemsArray = tipsModel["items"] as! NSArray;
              //  let count :Int = tipsModel["count"] as! Int;
                for object in tipsItemsArray {
                    let model = object as! NSDictionary;
                    let tipsText = (model["text"] as! String)
                    self.tipsList.append(tipsText);
                }
                self.lblComment.text = self.tipsList[0]
                MBProgressHUD.hide(for: self.view, animated: true)
                self.popUp()
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosePlace!.lat != 0 && self.choosePlace!.lng != 0 {
            self.requestCLLocation = CLLocation(latitude: self.choosePlace!.lat, longitude: self.choosePlace!.lng)
        }
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placesmark = placemarks {
                if placesmark.count > 0 {
                    let newPlacesmark = MKPlacemark(placemark: placesmark[0])
                    let item = MKMapItem(placemark: newPlacesmark)
                    item.name = self.nameLabel.text
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    
    func popUp() {
        manager.startUpdatingLocation()
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveLinear, animations: {
            self.viewPopUp.frame = CGRect(x: 29, y: 85, width: self.viewPopUp.frame.width, height: self.viewPopUp.frame.height)
                self.mapViewAnnotationSet()
        }, completion: nil)
    }
    
    func mapViewAnnotationSet() {
        let location = CLLocationCoordinate2D(latitude: self.choosePlace!.lat, longitude: self.choosePlace!.lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        annotation.title = self.nameLabel.text
    }
    
    @IBAction func closeButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.viewPopUp.frame = CGRect(x: 29, y: 1000, width: self.viewPopUp.frame.width, height: self.viewPopUp.frame.height)
        }, completion: { finished in
            self.viewPopUp.isHidden = true
            self.choosePlace = nil
            if let annotations = self.mapView?.annotations {
                for _annotation in annotations {
                    if let annotation = _annotation as? MKAnnotation
                    {
                        self.mapView.removeAnnotation(annotation)
                    }
                }
            }
        })
    }
}
