//
//  IndexPSITests.swift
//  IndexPSITests
//
//  Created by Javed Multani on 21/11/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import IndexPSI

class IndexPSITests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var mapViewController = MapViewController()
    
    override func setUp() {
        mapViewController = storyboard.instantiateViewController(withIdentifier :"MapViewController") as! MapViewController
        mapViewController.loadView()
      
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //MARK: - Segment test
    //Test Segment UserInteraction
    func testSegmentUserInteraction(){
         
        XCTAssertEqual(mapViewController.typeSegment.isUserInteractionEnabled,true)
        
    }
    //Test Segment Visibility
    func testSegmentIsHidden(){
        XCTAssertEqual(mapViewController.typeSegment.isHidden,false)
        
    }
      //Test Segment Items
    func testSegmentNumbers(){
        XCTAssertEqual(mapViewController.typeSegment.numberOfSegments,3)
        
    }
    //MARK: - MapView test
    //Test Map UserInteraction
       func testMapUserInteraction(){
           XCTAssertEqual(mapViewController.mapView.isUserInteractionEnabled,true)
           
       }
       //Test Map Visibility
       func testMapIsHidden(){
           XCTAssertEqual(mapViewController.mapView.isHidden,false)
           
       }
    //Test Map Zoom capability
    func testMapIsZoom(){
        XCTAssertEqual(mapViewController.mapView.isZoomEnabled,true)
     
    }
    
    //Test Map Rotaion capability
    func testMapIsRotate(){
        XCTAssertEqual(mapViewController.mapView.isRotateEnabled,true)
     
    }
    //Test Map scroll capability
    func testMapIsScroll(){
        XCTAssertEqual(mapViewController.mapView.isScrollEnabled,true)
     
    }
    //MARK: - Custom Object test
     //Test Latitude value
    func testLatitude(){
        let dic = ["latitude":1.35735,
                   "longitude":103.7] as [String:Any]
        let json = JSON(dic)
        let objLabelLocation = LabelLocation.init(json: json)
        
        XCTAssertEqual(objLabelLocation.latitude,1.35735)
        
    }
     //Test Longitude value
    func testLongitude(){
        let dic = ["latitude":1.35735,
                   "longitude":103.7] as [String:Any]
        let json = JSON(dic)
        let objLabelLocation = LabelLocation.init(json: json)
        
        XCTAssertEqual(objLabelLocation.longitude,103.7)
        
    }
    //Test Latitude value should not be String
    func testLatitudeStringValue(){
        let dic = ["latitude":"1.35735",
                   "longitude":"103.7"] as [String:Any]
        let json = JSON(dic)
        let objLabelLocation = LabelLocation.init(json: json)
        
        
        XCTAssertNotEqual(objLabelLocation.latitude,1.35735)
        
    }
    //Test Longitude value should not be String
    func testLongitudeStringValue(){
        let dic = ["latitude":"1.35735",
                   "longitude":"103.7"] as [String:Any]
        let json = JSON(dic)
        let objLabelLocation = LabelLocation.init(json: json)
        
        
        XCTAssertNotEqual(objLabelLocation.longitude,103.7)
        
    }
    //MARK: - Custom methods test
    //Test getFormattedValue method
    func testFormattedValue(){
        let value = mapViewController.getFormattedValue(region: "east")
        XCTAssertNotEqual(value, "")
    }
    //MARK: - API test
    //Test the internet connection
    func testConnection(){
        XCTAssert(isConnectedToNetwork())
    }
    //Test URL should not be blank
    func testURL(){
        let url = BaseURL + SubDomain + EndPoint
        XCTAssertEqual(url, "https://api.data.gov.sg/v1/environment/psi","URL should not be blank")
    }
    //Test Fetch Data
       func testFetchDataWithSuccessCode(){
           let url = BaseURL + SubDomain + EndPoint
           HttpRequestManager.sharedInstance.getRequestWithoutParams(endpointurl: url) { (result, error, msg, success) in
             
               XCTAssertNotEqual(success,false)
           }
       }
    //Test Region Data
    func testFetchDataWithRegion(){
        let url = BaseURL + SubDomain + EndPoint
        HttpRequestManager.sharedInstance.getRequestWithoutParams(endpointurl: url) { (result, error, msg, success) in
            guard let dataDic = result else{
                return
            }
            
            let region_metadata = dataDic["region_metadata"] as! [NSArray]
            XCTAssertNotEqual(region_metadata.count, 0)
        }
    }
    //Test Item Data
    func testFetchDataWithItems(){
        let url = BaseURL + SubDomain + EndPoint
        HttpRequestManager.sharedInstance.getRequestWithoutParams(endpointurl: url) { (result, error, msg, success) in
            guard let dataDic = result else{
                return
            }
            
            let items = dataDic["items"] as! [[String: Any]]
            XCTAssertNotEqual(items.count, 0)
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
