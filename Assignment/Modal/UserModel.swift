//
//  UserModel.swift
//  Assignment
//
//  Created by Waris on 11/6/20.
//

import UIKit

public class UserModel: NSObject {
    
    open var address : Address!
    open var company : Company!
    open var email : String!
    open var id : Int!
    open var name : String!
    open var phone : String!
    open var username : String!
    open var website : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    public init(fromDictionary dictionary: [String:Any]) {
        if let addressData = dictionary["address"] as? [String:Any] {
            address = Address(fromDictionary: addressData)
        }
        if let companyData = dictionary["company"] as? [String:Any] {
            company = Company(fromDictionary: companyData)
        }
        email = dictionary["email"] as? String
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        phone = dictionary["phone"] as? String
        username = dictionary["username"] as? String
        website = dictionary["website"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    open func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if address != nil {
            dictionary["address"] = address.toDictionary()
        }
        if company != nil {
            dictionary["company"] = company.toDictionary()
        }
        if email != nil {
            dictionary["email"] = email
        }
        if id != nil {
            dictionary["id"] = id
        }
        if name != nil {
            dictionary["name"] = name
        }
        if phone != nil {
            dictionary["phone"] = phone
        }
        if username != nil {
            dictionary["username"] = username
        }
        if website != nil {
            dictionary["website"] = website
        }
        return dictionary
    }
    
    var detailUserInfo: NSAttributedString {
        
        let attributedString = NSMutableAttributedString()
        
        
        var detail: String = K.lineChange
        detail.append("Email: " + self.email)
        detail.append(K.lineChange)
        detail.append("Phone: " + self.phone)
        detail.append(K.lineChange)
        
        var address: String = "Address: " + self.address.suite
        address.append(", ")
        address.append(self.address.street)
        address.append(", ")
        address.append(self.address.city)
        
        detail.append(address)
        
        detail.append(K.lineChange)
        detail.append("Website: " + self.website)
        
        detail.append(K.lineChange)
        detail.append("Company: " + self.company.name)
        
        attributedString.append(NSAttributedString(self.name, part2: detail))
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    // MARK: - Company -
    open class Company : NSObject {

        open var name : String!


        /**
         * Instantiate the instance using the passed dictionary values to set the properties values
         */
        public init(fromDictionary dictionary: [String:Any]) {
            name = dictionary["name"] as? String
        }

        /**
         * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
         */
        open func toDictionary() -> [String:Any] {
            var dictionary = [String:Any]()
            if name != nil {
                dictionary["name"] = name
            }
            return dictionary
        }

    }// End of Company
    
    // MARK: - Address -
    open class Address : NSObject {

        open var city : String!
        open var street : String!
        open var suite : String!
        open var zipcode : String!


        /**
         * Instantiate the instance using the passed dictionary values to set the properties values
         */
        required public init(fromDictionary dictionary: [String:Any]) {
            city = dictionary["city"] as? String
            street = dictionary["street"] as? String
            suite = dictionary["suite"] as? String
            zipcode = dictionary["zipcode"] as? String
        }

        /**
         * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
         */
        open func toDictionary() -> [String:Any] {
            var dictionary = [String:Any]()
            if city != nil {
                dictionary["city"] = city
            }
            if street != nil {
                dictionary["street"] = street
            }
            if suite != nil {
                dictionary["suite"] = suite
            }
            if zipcode != nil {
                dictionary["zipcode"] = zipcode
            }
            return dictionary
        }

    }// End of Address
}// End
