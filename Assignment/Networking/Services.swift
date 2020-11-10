//
//  Services.swift
//  Assignment
//
//  Created by Waris on 11/10/20.
//

import Foundation


extension APIHelper {
    
    fileprivate var serviceBase: String {
        get {
            return "users"
        }
    }
    
    fileprivate func getPath(_ method: String) -> String {
        
        return serviceBase + method
    }
    
    //MARK:- Get Users -
    /**
     
     `GET` api to get users.
     
     - Parameter success: UserModel response in case of success.
     - parameter failure: NSError in case of Failure.
     
     */
    open func getUsers(success: @escaping ([UserModel])->Void,
                       failure: @escaping (Error) -> Void) {
        
        let params: [String: String] = [:]
        self.get(getPath(""),
                  params: params,
                  failure: { (error) in
                    DispatchQueue.main.async(execute: {
                        failure(error)
                    })
                    
                  }) { (dataResponse, urlResponse) in
            if let json = self.getJSON(dataResponse, failure: failure) {
                DispatchQueue.main.async(execute: {
                    var users: [UserModel] = []
                    if let array = json as? [[String: Any]] {
                        for item in array {
                            users.append(UserModel(fromDictionary: item))
                        }
                    }
                    success(users)
                })
            }
            
        }
    }// End of Get Token
    
}
