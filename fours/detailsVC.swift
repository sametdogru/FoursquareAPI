//
//  detailsVC.swift
//  fours
//
//  Created by MacBookPro on 11.06.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//
/*
import UIKit
import Alamofire
import CoreLocation
import MBProgressHUD
import MapKit
import SDWebImage

class detailsVC: UIViewController,MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsTableView: UITableView!
    
    var choosePlace: venuesModel? = nil
    var manager = CLLocationManager()
    var tipsList : [String] = []
    var requestCLLocation = CLLocation()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        tipsTableView.delegate = self
        tipsTableView.dataSource = self
        
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
       
        
        getPhotosOfVenues()
        getListOfTips()
        
        nameLabel.text = choosePlace?.name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tipsTableView.dequeueReusableCell(withIdentifier: "TipsCell", for: indexPath) as! tipsTableViewCell;
        cell.tipsLabel.text = tipsList[indexPath.row]
        return cell;
    }
    
    func getPhotosOfVenues() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        var url : String = "https://api.foursquare.com/v2/venues/"+choosePlace!.id+"/photos?client_id=\(clientID)&client_secret=\(clientSecret)&v=20190521"
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
            
        }
    }

    func getListOfTips() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        var url : String = "https://api.foursquare.com/v2/venues/"+choosePlace!.id+"/tips?client_id=\(clientID)&client_secret=\(clientSecret)&v=20190521"
        print(url)
        AF.request(url).responseJSON { response in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let tipsModel = responseModel["tips"] as! NSDictionary;
                let tipsItemsArray = tipsModel["items"] as! NSArray;
                let count :Int = tipsModel["count"] as! Int;
                for object in tipsItemsArray {
                    let model = object as! NSDictionary;
                    var tipsText = (model["text"] as! String)
                    self.tipsList.append(tipsText);
                }
                DispatchQueue.main.async {
                    self.tipsTableView.reloadData()
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
   

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: choosePlace!.lat, longitude: choosePlace!.lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        annotation.title = nameLabel.text
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
    
    
    ///
    
}
*/
