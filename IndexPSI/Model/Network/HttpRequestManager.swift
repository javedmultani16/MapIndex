//
//  HttpRequestManager.swift
//  iOS
//
//  Created by Javed Multani on 21/11/2019.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

public enum RESPONSE_STATUS : NSInteger {
    case INVALID
    case VALID
    case MESSAGE
}


class HttpRequestManager {
    
    static let sharedInstance = HttpRequestManager()
    
    var responseObjectDic = Dictionary<String, AnyObject>()
    var URLString : String!
    var Message : String!
    let SOMETHING_WRONG = "Something went wrong, Please try again later"
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let url = BaseURL + SubDomain + EndPoint
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            url: .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    // METHODS
    init() {}
    
    //MARK:- POST Request
    
    func postParameterRequest(endpointurl:String, reqParameters:NSDictionary ,responseData:@escaping (_ data:Dictionary<String, AnyObject>?,_ error:NSError?,_ message:String, _ rStaus:Bool) -> Void)
    {
        print( "URL : \(endpointurl) \nParam :\( reqParameters) ")
        // ShowNetworkIndicator(xx: true)
        
        
        Alamofire.request(endpointurl, method: .post, parameters: reqParameters  as? [String: Any])
            
            .responseJSON { response in
                // ShowNetworkIndicator(xx: false)
                
                print(response.request ?? "")  // original URL request
                print(response.response ?? "") // URL response
                print(response.data ?? "")     // server data
                print(response.result)   // result of response serialization
                
                if let _ = response.result.error
                {
                    responseData(nil, response.result.error as NSError?, self.SOMETHING_WRONG,false)
                }
                else
                {
                    switch response.result {
                        
                    case .success(_):
                        
                        self.responseObjectDic = response.result.value as! Dictionary<String, AnyObject>
                        responseData(self.responseObjectDic, nil, "Success", true)
                        
                        guard let _:NSDictionary = response.result.value as? NSDictionary else {
                            print("Invalid tag information received from the service")
                            responseData(nil, nil, "Failed to parse data", false)
                            return
                        }
                        
                        
                        
                    case .failure(let error):
                        print(error)
                        responseData(nil, error as NSError?, "Failed", false)
                    }
                }
        }
    }
    
    func postJSONRequest(endpointurl:String, jsonParameters:[String: Any], responseData:@escaping (_ data:Dictionary<String, AnyObject>?,_ error:NSError?,_ message:String, _ rStaus:Bool) -> Void)
    {
        print( "URL : \(endpointurl) \nParam :\( jsonParameters) ")
        var dic = jsonParameters
        dic["DS"] = "KG"
        
        // ShowNetworkIndicator(xx: true)
        Alamofire.request(endpointurl, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                // ShowNetworkIndicator(xx: false)
                
                print(response.request ?? "")  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                
                if let _ = response.result.error
                {
                    responseData(nil, response.result.error as NSError?, self.SOMETHING_WRONG,false)
                }
                else
                {
                    switch response.result {
                        
                    case .success(_):
                        
                        guard let responseJSON:NSDictionary = response.result.value as? NSDictionary else {
                            print("Invalid tag information received from the service")
                            responseData(nil, nil, "Failed to parse data", false)
                            return
                        }
                        
                        //added new lines
                        self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                        responseData(self.responseObjectDic, nil, "Success", true)
                        
                    case .failure(let error):
                        print("\(error)")
                        responseData(nil, error as NSError?, "Failed", false)
                    }
                }
        }
    }
    
    //MARK:- GET Request1
    func getRequestWithoutParams(endpointurl:String,responseData:@escaping (_ data:Dictionary<String, AnyObject>?,_ error:NSError?,_ message:String, _ rStaus:Bool)  -> Void)
    {
        print( "URL : \(endpointurl)")
        // ShowNetworkIndicator(xx: true)
        HttpRequestManager.Manager.request(endpointurl, method : .get)
            .responseJSON { response in
                // ShowNetworkIndicator(xx: false)
                
                print(response.request ?? "")  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                if let _ = response.result.error
                {
                    responseData(nil, response.result.error as NSError?, self.SOMETHING_WRONG,false)
                }
                else
                {
                    switch response.result {
                        
                    case .success(_):
                        
                        guard let responseJSON:NSDictionary = response.result.value as? NSDictionary else {
                            print("Invalid tag information received from the service")
                            responseData(nil, nil, "Failed to parse data", false)
                            return
                        }
                        
                        self.Message = ("Success")//because of your api structure is different
                        var st:Bool = true
                        switch (1) {//because of your api structure is different
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                            st = true
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                            st = false
                            break
                            
                        default :
                            break
                            
                        }
                        responseData(self.responseObjectDic, nil, self.Message, st)
                        
                    case .failure(let error):
                        print(error)
                        responseData(nil, error as NSError?, "Failed", false)
                    }
                }
        }
    }
    
    //MARK:- GET Request
    func getRequest(endpointurl:String,parameters:NSDictionary,responseData:@escaping (_ data:Dictionary<String, AnyObject>?,_ error:NSError?,_ message:String, _ rStaus:Bool) -> Void)
    {
        print( "URL : \(endpointurl) \nParam :\( parameters) ")
        //   ShowNetworkIndicator(xx: true)
        Alamofire.request(endpointurl , method: .get, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                //     ShowNetworkIndicator(xx: false)
                
                print(response.request ?? "")  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                
                if let _ = response.result.error
                {
                    responseData(nil, response.result.error as NSError?, self.SOMETHING_WRONG,false)
                }
                else
                {
                    switch response.result {
                        
                    case .success(_):
                        
                        guard let responseJSON:NSDictionary = response.result.value as? NSDictionary else {
                            print("Invalid tag information received from the service")
                            responseData(nil, nil, "Failed to parse data", false)
                            return
                        }
                        
                        self.Message = (responseJSON["message"] as! String)
                        var st:Bool = false
                        switch (responseJSON["success"] as! NSInteger) {
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                            st = true
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                            st = false
                            break
                            
                        default :
                            break
                            
                        }
                        responseData(self.responseObjectDic, nil, self.Message, st)
                        
                    case .failure(let error):
                        print(error)
                        responseData(nil, error as NSError?, "Failed", false)
                    }
                }
        }
    }
    
    
    //MARK:- PUT Request
    func putRequest(endpointurl:String, jsonParameters:[String : Any],responseData:@escaping (_ data:Dictionary<String, AnyObject>?,_ error:NSError?,_ message:String, _ rStaus:Bool) -> Void)
    {
        //ShowNetworkIndicator(xx: true)
        Alamofire.request(endpointurl, method: .put, parameters: jsonParameters)
            .responseJSON { response in
                //  ShowNetworkIndicator(xx: false)
                
                print(response.request ?? "")  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                
                if let _ = response.result.error
                {
                    responseData(nil, response.result.error as NSError?, self.SOMETHING_WRONG,false)
                }
                else
                {
                    switch response.result {
                        
                    case .success(_):
                        
                        guard let responseJSON:NSDictionary = response.result.value as? NSDictionary else {
                            print("Invalid tag information received from the service")
                            responseData(nil, nil, "Failed to parse data", false)
                            return
                        }
                        
                        self.Message = (responseJSON["message"] as! String)
                        var st:Bool = false
                        switch (responseJSON["success"] as! NSInteger) {
                            
                        case RESPONSE_STATUS.VALID.rawValue :
                            self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                            st = true
                            break
                            
                        case RESPONSE_STATUS.INVALID.rawValue :
                            self.responseObjectDic = (responseJSON as AnyObject?) as! Dictionary<String, AnyObject>
                            st = false
                            break
                            
                        default :
                            break
                            
                        }
                        responseData(self.responseObjectDic, nil, self.Message, st)
                        
                    case .failure(let error):
                        print(error)
                        responseData(nil, error as NSError?, "Failed", false)
                    }
                }
        }
    }
    
    
}
