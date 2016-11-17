//
//  ViewController.swift
//  HonoluluArt
//
//  Created by Pavel Nikitinskiy on 11/17/16.
//  Copyright © 2016 Pavel Nikitinskiy. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    var artworks = [Artwork]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // set honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        loadInitialData()
        mapView.addAnnotations(artworks)
        mapView.delegate = self
        
    }
    
    func loadInitialData() {
        let fileName = Bundle.main.path(forResource:"PublicArt", ofType: "json")
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: NSData.ReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        var jsonObject: Any? = nil
        if let data = data {
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        if let jsonObject = jsonObject as? [String: Any],
            let jsonData = JSONValue.fromObject(object: jsonObject as AnyObject)?["data"]?.array {
            
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    let artwork = Artwork.fromJSON(artworkJSON) {
                    artworks.append(artwork)
                }
            }
        }
    }
    func centerMapOnLocation(location: CLLocation)  {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

