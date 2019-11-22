//
//  Reading.swift
//
//  Created by Javed Multani on 21/11/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Reading: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kReadingEastKey: String = "east"
  private let kReadingNationalKey: String = "national"
  private let kReadingSouthKey: String = "south"
  private let kReadingCentralKey: String = "central"
  private let kReadingNorthKey: String = "north"
  private let kReadingWestKey: String = "west"

  // MARK: Properties
  public var east: Int?
  public var national: Int?
  public var south: Int?
  public var central: Int?
  public var north: Int?
  public var west: Int?

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
    east = json[kReadingEastKey].int
    national = json[kReadingNationalKey].int
    south = json[kReadingSouthKey].int
    central = json[kReadingCentralKey].int
    north = json[kReadingNorthKey].int
    west = json[kReadingWestKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = east { dictionary[kReadingEastKey] = value }
    if let value = national { dictionary[kReadingNationalKey] = value }
    if let value = south { dictionary[kReadingSouthKey] = value }
    if let value = central { dictionary[kReadingCentralKey] = value }
    if let value = north { dictionary[kReadingNorthKey] = value }
    if let value = west { dictionary[kReadingWestKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.east = aDecoder.decodeObject(forKey: kReadingEastKey) as? Int
    self.national = aDecoder.decodeObject(forKey: kReadingNationalKey) as? Int
    self.south = aDecoder.decodeObject(forKey: kReadingSouthKey) as? Int
    self.central = aDecoder.decodeObject(forKey: kReadingCentralKey) as? Int
    self.north = aDecoder.decodeObject(forKey: kReadingNorthKey) as? Int
    self.west = aDecoder.decodeObject(forKey: kReadingWestKey) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(east, forKey: kReadingEastKey)
    aCoder.encode(national, forKey: kReadingNationalKey)
    aCoder.encode(south, forKey: kReadingSouthKey)
    aCoder.encode(central, forKey: kReadingCentralKey)
    aCoder.encode(north, forKey: kReadingNorthKey)
    aCoder.encode(west, forKey: kReadingWestKey)
  }

}
