//
//  MapViewController.swift
//  IndexPSI
//
//  Created by Javed Multani on 21/11/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class MapViewController: BaseViewController {
    
    @IBOutlet var typeSegment: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    //Region Array for pin on map
    var regionArray:[Region] = [Region]()
    
    //Reading objects
    var o3_sub_index:Reading? = nil
    var pm10_twenty_four_hourly:Reading? = nil
    var pm10_sub_index:Reading? = nil
    var co_sub_index:Reading? = nil
    var pm25_twenty_four_hourly:Reading? = nil
    var so2_sub_index:Reading? = nil
    var co_eight_hour_max:Reading? = nil
    var no2_one_hour_max:Reading? = nil
    var so2_twenty_four_hourly:Reading? = nil
    var pm25_sub_index:Reading? = nil
    var psi_twenty_four_hourly:Reading? = nil
    var o3_eight_hour_max:Reading? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.fetchData()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - API call
    func fetchData() {
        if isConnectedToNetwork(){
            self.createMainLoaderInView(message: "Loading")
            let url = BaseURL + SubDomain + EndPoint
            HttpRequestManager.sharedInstance.getRequestWithoutParams(endpointurl: url) { (result, error, message, success) in
                
                self.stopLoaderAnimation(vc: self)
                guard let dataDic = result else{
                    self.showAlertMessage(vc: self, titleStr: APP_NAME, messageStr: AlertWarningMsg)
                    return
                }
                
                let region_metadata = dataDic["region_metadata"] as! [NSArray]
                let swiftArray = region_metadata as AnyObject as! [Any]
                for i in 0..<swiftArray.count {
                    let json = JSON(swiftArray[i])
                    let obj : Region = Region.init(json: json)
                    self.regionArray.append(obj)
                    
                }
                
                
                if let items = dataDic["items"] as? [[String: Any]] {
                    for item in items {
                        if let reading = item["readings"] as? [String: Any] {
                            for (_,dict) in reading.enumerated() {
                                print(dict.key)
                                print(dict.value)
                                if let value = dict.value as? [String: Int] {
                                    if dict.key == "o3_sub_index"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.o3_sub_index = obj
                                    }else if dict.key == "pm10_twenty_four_hourly"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.pm10_twenty_four_hourly = obj
                                    }
                                    else if dict.key == "pm10_sub_index"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.pm10_sub_index = obj
                                    }
                                    else if dict.key == "co_sub_index"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.co_sub_index = obj
                                    }
                                    else if dict.key == "pm25_twenty_four_hourly"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.pm25_twenty_four_hourly = obj
                                    }
                                    else if dict.key == "so2_sub_index"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.so2_sub_index = obj
                                    }
                                    else if dict.key == "co_eight_hour_max"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.co_eight_hour_max = obj
                                    }
                                    else if dict.key == "no2_one_hour_max"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.no2_one_hour_max = obj
                                    }
                                    else if dict.key == "so2_twenty_four_hourly"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.so2_twenty_four_hourly = obj
                                    }
                                    else if dict.key == "pm25_sub_index"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.pm25_sub_index = obj
                                    }
                                    else if dict.key == "psi_twenty_four_hourly"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.psi_twenty_four_hourly = obj
                                    }
                                    else if dict.key == "o3_eight_hour_max"{
                                        let json = JSON(value)
                                        let obj : Reading = Reading.init(json: json)
                                        self.o3_eight_hour_max = obj
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                //Once data collected adding pin here
                runOnMainThread {
                    self.addPins()
                }
            }
        }else{
            self.showAlertMessage(vc: self, titleStr: APP_NAME, messageStr: AlertNetMsg)
        }
    }
    //MARK: - Adding pin
    //This method is used for adding pin on map
    func addPins() {
        
        var lastCoordinate = CLLocationCoordinate2D()
        for region in regionArray{
            
            let annotation = PSIAnnotation()
            
            let lat:Double = Double(region.labelLocation!.latitude!)
            let long:Double = Double(region.labelLocation!.longitude!)
            
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat , longitude: long)
            lastCoordinate = centerCoordinate
            annotation.coordinate = centerCoordinate
            annotation.title = region.name!
            mapView.addAnnotation(annotation)
        }
        let center = lastCoordinate
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
    }
    //MARK: - Segment Handler
    //This method is used for change map type using segment control
    @IBAction func typeSegmenthandler(_ sender: Any) {
        if self.typeSegment.selectedSegmentIndex == 0{
            self.mapView.mapType = .standard
        }else if self.typeSegment.selectedSegmentIndex == 1{
            self.mapView.mapType = .satellite
        }else{
            self.mapView.mapType = .hybrid
        }
        
    }
}

extension MapViewController: MKMapViewDelegate  {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "PSIAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            
            annotationView!.annotation = annotation
        }
        
        configureDetailView(annotationView: annotationView!)
        return annotationView
    }
    
    //This method is used for show annotation view
    func configureDetailView(annotationView: MKAnnotationView) {
        guard let view = annotationView.annotation as? PSIAnnotation else {
            return
        }
        print("detect",view.title ?? "")
        let detailView = PSIDetailView.fromNib(xibName: "PSIDetailView") as! PSIDetailView
        
        if view.title == "west"{
            detailView.detailLabel.text =  getFormattedValue(region: "west")
        }else if view.title == "national"{
            detailView.detailLabel.text =  getFormattedValue(region: "national")
        }else if view.title == "east"{
            detailView.detailLabel.text =  getFormattedValue(region: "east")
        }else if view.title == "central"{
            detailView.detailLabel.text =  getFormattedValue(region: "central")
        }else if view.title == "south"{
            detailView.detailLabel.text =  getFormattedValue(region: "south")
        }else if view.title == "north"{
            detailView.detailLabel.text =  getFormattedValue(region: "north")
        }
        
        annotationView.detailCalloutAccessoryView = detailView
    }
    
    //This method is used for the formation of the string
    func getFormattedValue(region:String)->String{
        
        switch region {
        case "east":
            var formattedString = ""
            formattedString =  formattedString + "o3_sub_index : \(self.o3_sub_index?.east! ?? 0) \n"
            formattedString =  formattedString + "pm10_twenty_four_hourly : \(self.pm10_twenty_four_hourly?.east! ?? 0) \n"
            formattedString =  formattedString + "pm10_sub_index : \(self.pm10_sub_index?.east! ?? 0) \n"
            formattedString =  formattedString + "co_sub_index : \(self.co_sub_index?.east! ?? 0) \n"
            formattedString =  formattedString + "pm25_twenty_four_hourly : \(self.pm25_twenty_four_hourly?.east! ?? 0) \n"
            formattedString =  formattedString + "so2_sub_index : \(self.so2_sub_index?.east! ?? 0) \n"
            formattedString =  formattedString + "co_eight_hour_max : \(self.co_eight_hour_max?.east! ?? 0) \n"
            formattedString =  formattedString + "no2_one_hour_max : \(self.no2_one_hour_max?.east! ?? 0) \n"
            formattedString =  formattedString + "so2_twenty_four_hourly : \(self.so2_twenty_four_hourly?.east! ?? 0) \n"
            formattedString =  formattedString + "pm25_sub_index : \(self.pm25_sub_index?.east! ?? 0) \n"
            formattedString =  formattedString + "psi_twenty_four_hourly : \(self.psi_twenty_four_hourly?.east! ?? 0) \n"
            formattedString =  formattedString + "o3_eight_hour_max : \(self.o3_eight_hour_max?.east! ?? 0) \n"
            
            return formattedString
            
        case "west":
            var formattedString = ""
            formattedString =  formattedString + "o3_sub_index : \(self.o3_sub_index?.west! ?? 0) \n"
            formattedString =  formattedString + "pm10_twenty_four_hourly : \(self.pm10_twenty_four_hourly?.west! ?? 0) \n"
            formattedString =  formattedString + "pm10_sub_index : \(self.pm10_sub_index?.west! ?? 0) \n"
            formattedString =  formattedString + "co_sub_index : \(self.co_sub_index?.west! ?? 0) \n"
            formattedString =  formattedString + "pm25_twenty_four_hourly : \(self.pm25_twenty_four_hourly?.west! ?? 0) \n"
            formattedString =  formattedString + "so2_sub_index : \(self.so2_sub_index?.west! ?? 0) \n"
            formattedString =  formattedString + "co_eight_hour_max : \(self.co_eight_hour_max?.west! ?? 0) \n"
            formattedString =  formattedString + "no2_one_hour_max : \(self.no2_one_hour_max?.west! ?? 0) \n"
            formattedString =  formattedString + "so2_twenty_four_hourly : \(self.so2_twenty_four_hourly?.west! ?? 0) \n"
            formattedString =  formattedString + "pm25_sub_index : \(self.pm25_sub_index?.west! ?? 0) \n"
            formattedString =  formattedString + "psi_twenty_four_hourly : \(self.psi_twenty_four_hourly?.west! ?? 0) \n"
            formattedString =  formattedString + "o3_eight_hour_max : \(self.o3_eight_hour_max?.west! ?? 0) \n"
            
            return formattedString
        case "national":
            var formattedString = ""
            formattedString =  formattedString + "o3_sub_index : \(self.o3_sub_index?.national! ?? 0) \n"
            formattedString =  formattedString + "pm10_twenty_four_hourly : \(self.pm10_twenty_four_hourly?.national! ?? 0) \n"
            formattedString =  formattedString + "pm10_sub_index : \(self.pm10_sub_index?.national! ?? 0) \n"
            formattedString =  formattedString + "co_sub_index : \(self.co_sub_index?.national! ?? 0) \n"
            formattedString =  formattedString + "pm25_twenty_four_hourly : \(self.pm25_twenty_four_hourly?.national! ?? 0) \n"
            formattedString =  formattedString + "so2_sub_index : \(self.so2_sub_index?.national! ?? 0) \n"
            formattedString =  formattedString + "co_eight_hour_max : \(self.co_eight_hour_max?.national! ?? 0) \n"
            formattedString =  formattedString + "no2_one_hour_max : \(self.no2_one_hour_max?.national! ?? 0) \n"
            formattedString =  formattedString + "so2_twenty_four_hourly : \(self.so2_twenty_four_hourly?.national! ?? 0) \n"
            formattedString =  formattedString + "pm25_sub_index : \(self.pm25_sub_index?.national! ?? 0) \n"
            formattedString =  formattedString + "psi_twenty_four_hourly : \(self.psi_twenty_four_hourly?.national! ?? 0) \n"
            formattedString =  formattedString + "o3_eight_hour_max : \(self.o3_eight_hour_max?.national! ?? 0) \n"
            
            return formattedString
        case "central":
            var formattedString = ""
            formattedString =  formattedString + "o3_sub_index : \(self.o3_sub_index?.central! ?? 0) \n"
            formattedString =  formattedString + "pm10_twenty_four_hourly : \(self.pm10_twenty_four_hourly?.central! ?? 0) \n"
            formattedString =  formattedString + "pm10_sub_index : \(self.pm10_sub_index?.central! ?? 0) \n"
            formattedString =  formattedString + "co_sub_index : \(self.co_sub_index?.central! ?? 0) \n"
            formattedString =  formattedString + "pm25_twenty_four_hourly : \(self.pm25_twenty_four_hourly?.central! ?? 0) \n"
            formattedString =  formattedString + "so2_sub_index : \(self.so2_sub_index?.central! ?? 0) \n"
            formattedString =  formattedString + "co_eight_hour_max : \(self.co_eight_hour_max?.central! ?? 0) \n"
            formattedString =  formattedString + "no2_one_hour_max : \(self.no2_one_hour_max?.central! ?? 0) \n"
            formattedString =  formattedString + "so2_twenty_four_hourly : \(self.so2_twenty_four_hourly?.central! ?? 0) \n"
            formattedString =  formattedString + "pm25_sub_index : \(self.pm25_sub_index?.central! ?? 0) \n"
            formattedString =  formattedString + "psi_twenty_four_hourly : \(self.psi_twenty_four_hourly?.central! ?? 0) \n"
            formattedString =  formattedString + "o3_eight_hour_max : \(self.o3_eight_hour_max?.central! ?? 0) \n"
            
            return formattedString
        case "south":
            var formattedString = ""
            formattedString =  formattedString + "o3_sub_index : \(self.o3_sub_index?.south! ?? 0) \n"
            formattedString =  formattedString + "pm10_twenty_four_hourly : \(self.pm10_twenty_four_hourly?.south! ?? 0) \n"
            formattedString =  formattedString + "pm10_sub_index : \(self.pm10_sub_index?.south! ?? 0) \n"
            formattedString =  formattedString + "co_sub_index : \(self.co_sub_index?.south! ?? 0) \n"
            formattedString =  formattedString + "pm25_twenty_four_hourly : \(self.pm25_twenty_four_hourly?.south! ?? 0) \n"
            formattedString =  formattedString + "so2_sub_index : \(self.so2_sub_index?.south! ?? 0) \n"
            formattedString =  formattedString + "co_eight_hour_max : \(self.co_eight_hour_max?.south! ?? 0) \n"
            formattedString =  formattedString + "no2_one_hour_max : \(self.no2_one_hour_max?.south! ?? 0) \n"
            formattedString =  formattedString + "so2_twenty_four_hourly : \(self.so2_twenty_four_hourly?.south! ?? 0) \n"
            formattedString =  formattedString + "pm25_sub_index : \(self.pm25_sub_index?.south! ?? 0) \n"
            formattedString =  formattedString + "psi_twenty_four_hourly : \(self.psi_twenty_four_hourly?.south! ?? 0) \n"
            formattedString =  formattedString + "o3_eight_hour_max : \(self.o3_eight_hour_max?.south! ?? 0) \n"
            
            return formattedString
        case "north":
            var formattedString = ""
            formattedString =  formattedString + "o3_sub_index : \(self.o3_sub_index?.north! ?? 0) \n"
            formattedString =  formattedString + "pm10_twenty_four_hourly : \(self.pm10_twenty_four_hourly?.north! ?? 0) \n"
            formattedString =  formattedString + "pm10_sub_index : \(self.pm10_sub_index?.north! ?? 0) \n"
            formattedString =  formattedString + "co_sub_index : \(self.co_sub_index?.north! ?? 0) \n"
            formattedString =  formattedString + "pm25_twenty_four_hourly : \(self.pm25_twenty_four_hourly?.north! ?? 0) \n"
            formattedString =  formattedString + "so2_sub_index : \(self.so2_sub_index?.north! ?? 0) \n"
            formattedString =  formattedString + "co_eight_hour_max : \(self.co_eight_hour_max?.north! ?? 0) \n"
            formattedString =  formattedString + "no2_one_hour_max : \(self.no2_one_hour_max?.north! ?? 0) \n"
            formattedString =  formattedString + "so2_twenty_four_hourly : \(self.so2_twenty_four_hourly?.north! ?? 0) \n"
            formattedString =  formattedString + "pm25_sub_index : \(self.pm25_sub_index?.north! ?? 0) \n"
            formattedString =  formattedString + "psi_twenty_four_hourly : \(self.psi_twenty_four_hourly?.north! ?? 0) \n"
            formattedString =  formattedString + "o3_eight_hour_max : \(self.o3_eight_hour_max?.north! ?? 0) \n"
            
            return formattedString
        default:
            var formattedString = ""
            formattedString =  " "
            return formattedString
        }
        
        
    }
}

extension UIView {
    class func fromNib<T : UIView>(xibName: String) -> T {
        return Bundle.main.loadNibNamed(xibName, owner: nil, options: nil )![0] as! T
    }
}

