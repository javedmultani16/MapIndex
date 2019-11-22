//
//  Region.swift
//
//  Created by Javed Multani on 21/11/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Region: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kRegionNameKey: String = "name"
  private let kRegionLabelLocationKey: String = "label_location"

  // MARK: Properties
  public var name: String?
  public var labelLocation: LabelLocation?

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
    name = json[kRegionNameKey].string
    labelLocation = LabelLocation(json: json[kRegionLabelLocationKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kRegionNameKey] = value }
    if let value = labelLocation { dictionary[kRegionLabelLocationKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kRegionNameKey) as? String
    self.labelLocation = aDecoder.decodeObject(forKey: kRegionLabelLocationKey) as? LabelLocation
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kRegionNameKey)
    aCoder.encode(labelLocation, forKey: kRegionLabelLocationKey)
  }

}
