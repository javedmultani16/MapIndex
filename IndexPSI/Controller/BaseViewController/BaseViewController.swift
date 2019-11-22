//
//  BaseViewController.swift
//  SMT
//
//  Created by Javed Multani on 19/11/2019.
//  Copyright © 2019 Javid Multani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Foundation
import Alamofire


class BaseViewController: UIViewController,NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: - Loader Methods
    func createMainLoaderInView(message : String) {
        runOnMainThread {
            let size = CGSize(width: 60, height: 60)
            self.startAnimating(size, message: message, type: .ballSpinFadeLoader)//ballClipRotatePulse
        }
    }
    
    
    func stopLoaderAnimation(vc : UIViewController) {
        runOnMainThread {
            self.stopAnimating()
        }
    }
    public func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        vc.present(alert, animated: true, completion: nil)
    }
}
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
