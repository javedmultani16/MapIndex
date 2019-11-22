//
//  LabelLocation.swift
//
//  Created by Javed Multani on 21/11/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class LabelLocation: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kLabelLocationLongitudeKey: String = "longitude"
  private let kLabelLocationLatitudeKey: String = "latitude"

  // MARK: Properties
  public var longitude: Float?
  public var latitude: Float?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    longitude = json[kLabelLocationLongitudeKey].float
    latitude = json[kLabelLocationLatitudeKey].float
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = longitude { dictionary[kLabelLocationLongitudeKey] = value }
    if let value = latitude { dictionary[kLabelLocationLatitudeKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.longitude = aDecoder.decodeObject(forKey: kLabelLocationLongitudeKey) as? Float
    self.latitude = aDecoder.decodeObject(forKey: kLabelLocationLatitudeKey) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(longitude, forKey: kLabelLocationLongitudeKey)
    aCoder.encode(latitude, forKey: kLabelLocationLatitudeKey)
  }

}
