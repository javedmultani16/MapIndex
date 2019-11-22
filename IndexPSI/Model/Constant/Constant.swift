

import Foundation
import UIKit
import SystemConfiguration
import NVActivityIndicatorView


//MARK:
//MARK: Application related variables

let APP_CONTEXT = UIApplication.shared.delegate as! AppDelegate
//public let APP_NAME: String = Bundle.main.infoDictionary!["CFBundleName"] as! String
public let APP_NAME = "IndexPSI"
public let APP_VERSION: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
public let APP_Bundle_Identifier =  Bundle.main.bundleIdentifier

//API Call URL:
public let BaseURL:String = "https://api.data.gov.sg/"
public let SubDomain:String = "v1/environment/"
public let EndPoint:String = "psi"

public func DegreesToRadians(degrees: Float) -> Float {
    return Float(Double(degrees) * Double.pi / 180)
}

//MARK: - Check Device is iPad or not

public func isIpad( ) ->Bool{
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return false
    case .pad:
        return true
    case .unspecified:
        return false
        
    default :
        return false
    }
}
public let AlertWarningMsg = "Something went wrong,Please try again later"
public let AlertNetMsg = "No Internet Connnction, Please check your internet connctivity"

//MARK: - iOS version checking Functions

func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedSame
}

func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedDescending
}

func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedAscending
}

func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
}

func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedDescending
}



//MARK: - Count enum
func enumCount<T: Hashable>(_: T.Type) -> Int {
    var i = 1
    while (withUnsafePointer(to: &i, {
        return $0.withMemoryRebound(to: T.self, capacity: 1, { return $0.pointee })
    }).hashValue != 0) {
        i += 1
    }
    return i
}


func arrayEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

func enumValues<T>(from array: AnyIterator<T>) -> [T.RawValue] where T: RawRepresentable {
    return array.map { $0.rawValue }
}


//MARK: - Get image from image name

public func Set_Local_Image(_ imageName :String) -> UIImage
{
    return UIImage(named:imageName)!
}




//MARK: - Font

public func THEME_FONT_REGULAR(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue", size: size)!
}

public func THEME_FONT_MEDIUM(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Medium", size: size)!
}

public func THEME_FONT_MEDIUM_ITALIC(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-MediumItalic", size: size)!
}

public func THEME_FONT_LIGHT(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Light", size: size)!
}

public func THEME_FONT_LIGHT_ITALIC(size: CGFloat) -> UIFont {
    return UIFont(name: "Helvetica-LightItalic", size: size)!
}

public func THEME_FONT_BOLD(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: size)!
}

public func THEME_FONT_BOLD_ITALIC(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-BoldItalic", size: size)!
}


//MARK: - Color functions

public func COLOR_CUSTOM(_ Red: Float, _ Green: Float , _ Blue: Float, _ Alpha: Float) -> UIColor {
    return  UIColor (red:  CGFloat(Red)/255.0, green: CGFloat(Green)/255.0, blue: CGFloat(Blue)/255.0, alpha: CGFloat(Alpha))
}

public func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func randomColor(_ alpha : CGFloat = 1.0) -> UIColor {
    let r: UInt32 = arc4random_uniform(255)
    let g: UInt32 = arc4random_uniform(255)
    let b: UInt32 = arc4random_uniform(255)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}


public let APP_TEXTCOLOR: UIColor = UIColor.white
public let CLEAR_COLOR :UIColor = UIColor.clear

public let APP_THEME_COLOR :UIColor = COLOR_CUSTOM(233,120,47,1)

//MARK:- Log trace

public func DLog<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        guard let object = object else { return }
        print("***** \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    #endif
}




//MARK: - Get current time stamp

public var CurrentTimeStamp: String {
    return "\(Date().timeIntervalSince1970 * 1000)"
}

public var CurrentTimeStampInSecond: Int {
    return Int(Date().timeIntervalSince1970)
}



//MARK: - Image rotate by degree

public func imageRotatedByDegrees(degrees: CGFloat, Image: UIImage) -> UIImage {
    let size = Image.size
    
    UIGraphicsBeginImageContext(size)
    
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    bitmap.translateBy(x: size.width / 2, y: size.height / 2)
    //Rotate the image context
    bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
    //Now, draw the rotated/scaled image into the context
    bitmap.scaleBy(x: 1.0, y: -1.0)
    
    let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
    
    bitmap.draw(Image.cgImage!, in: CGRect(origin: origin, size: size))
    
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}

//MARK:
//MARK: AWS Default
struct AWSConstants {
    public enum ExceptionString: String {
        /// Thrown during sign-up when email is already taken.
        case aliasExistsException = "AliasExistsException"
        /// Thrown when a user is not authorized to access the requested resource.
        case notAuthorizedException = "NotAuthorizedException"
        /// Thrown when the requested resource (for example, a dataset or record) does not exist.
        case resourceNotFoundException = "ResourceNotFoundException"
        /// Thrown when a user tries to use a login which is already linked to another account.
        case resourceConflictException = "ResourceConflictException"
        /// Thrown for missing or bad input parameter(s).
        case invalidParameterException = "InvalidParameterException"
        /// Thrown during sign-up when username is taken.
        case usernameExistsException = "UsernameExistsException"
        /// Thrown when user has not confirmed his email address.
        case userNotConfirmedException = "UserNotConfirmedException"
        /// Thrown when specified user does not exist.
        case userNotFoundException = "UserNotFoundException"
    }
    
}



struct Constants {
    
    enum CurrentDevice : Int {
        case Phone // iPhone and iPod touch style UI
        case Pad // iPad style UI
    }
    
    struct MixpanelConstants {
        static let activeScreen = "Active Screen";
    }
    
    struct CrashlyticsConstants {
        static let userType = "User Type";
    }
    
}

//MARK: - Loader
public func createSmallLoaderInView() -> NVActivityIndicatorView {
    let loaderSize : CGFloat = 30.0
    let frame = CGRect(x: 0, y: 0, width: loaderSize, height: loaderSize)
    let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: .ballRotateChase)
    activityIndicatorView.color = UIColor.black
    return activityIndicatorView
}




//MARK: - Rounded two digit
//Rounded two digit value

extension Double{
    // let x = Double(0.123456789).roundToPlaces(4)  // x becomes 0.1235 under Swift 2
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

///MARK: - Check Internet connection

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
        
    }) else {
        
        return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
    
}



