//
//  MapControler.swift
//  projet swift
//
//  Created by Developer on 14/06/2018.
//  Copyright © 2018 esgi. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
class MapControler :UIViewController{
    
    var gmsFetcher: GMSAutocompleteFetcher!
    var locationManager = CLLocationManager()

    var foodtype=""

    override func loadView() {
        
        super.loadView()
        let latESGI = 48.849218
        let lngESGI = 2.389862
        if(CLLocationManager.locationServicesEnabled()){
            var location:CLLocationCoordinate2D? = locationManager.location?.coordinate;


            if(location == nil){
                location = CLLocationCoordinate2D(latitude: latESGI, longitude: lngESGI);
               
            }

            let camera = GMSCameraPosition.camera(withLatitude: location!.latitude, longitude:  location!.longitude, zoom: 17)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            view=mapView
            locationManager.requestAlwaysAuthorization();
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location!.latitude, longitude: location!.longitude)
            marker.title = "YOU"
            marker.snippet = "your current position"
            marker.map = mapView

       
            let origin = "\(location!.latitude),\(location!.longitude)"
            let urlToFindFood="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+origin+"&radius=&rankby=distance&keyword="+foodtype+"&key=AIzaSyBsh168p9nXIw6W2jv0aInS2j17yEnx620"
            
            
            var positionMiamMiam=""
            Alamofire.request(urlToFindFood).responseJSON { response in
                do{
                    let json = try JSON(data: response.data!)
                    print("\njson: \n")
                    print(json)
                    let positions = json["results"].arrayValue
                    let lat = positions[0]["geometry"]["location"]["lat"].stringValue
                    let lng = positions[0]["geometry"]["location"]["lng"].stringValue
                    print(positions[0]["geometry"]["location"]["lat"])
                    print(positions[0]["geometry"]["location"]["lng"])
                    print("\n coordonées : "+lat+" "+lng)
                    positionMiamMiam = (lat + "," + lng)
                    let markerTarget = GMSMarker()
                    markerTarget.position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
                    let name = positions[0]["name"].stringValue
                    markerTarget.title = self.foodtype
                    markerTarget.snippet = name
                    markerTarget.map = mapView
                    mapView.selectedMarker=markerTarget
                    let urlToFindRoute = "https://maps.googleapis.com/maps/api/directions/json?origin="+origin+"&destination="+positionMiamMiam+"&mode=walking&key=AIzaSyBuX36jdFaFC4ge7pfKcMdIzdlktWtmT9c"
                    Alamofire.request(urlToFindRoute).responseJSON { response in
                        do{
                            let json = try JSON(data: response.data!)
                            //print(json)
                            let routes = json["routes"].arrayValue
                            for route in routes
                            {
                                let distance : Double = Double(route["legs"][0]["distance"]["value"].stringValue)!
                                if(distance <= 800){
                                    mapView.animate(toZoom: 16)
                                }
                                else if(distance > 800 && distance <= 1500){
                                    mapView.animate(toZoom: 15)
                                }else if(distance > 1500){
                                    mapView.animate(toZoom: 14)
                                }
                                let routeOverviewPolyline = route["overview_polyline"].dictionary
                                let points = routeOverviewPolyline?["points"]?.stringValue
                                let path = GMSPath.init(fromEncodedPath: points!)
                                
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeColor = .blue
                                polyline.strokeWidth = 2.0
                                polyline.map = mapView
                                
                            }
                        }catch{
                            print(" pas cool")
                        }
                    }
                    
                 }catch{
                    print("vraiment pas cool")
                }
            }
            
            
            print("\nthe end\n")
        }else{
            
            print("\nerreur : services de localisation désactivé\n");
            exit(0);
        }
        
        

    }
}
