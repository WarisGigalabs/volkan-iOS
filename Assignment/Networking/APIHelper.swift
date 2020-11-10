//
//  APIHelper.swift
//  Assignment
//
//  Created by Waris on 11/6/20.
//

import UIKit

public let ServicesManager = APIHelper.sharedInstance

open class APIHelper: NSObject {
    
    public static let sharedInstance = APIHelper()
    
    private var baseURI: String = ""
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    var dataTask: URLSessionDataTask?
    
    open var ROOT_API: String {
        get {
            return baseURI
        }
        set (new_path) {
            baseURI = new_path
            
        }
    }
    
    override init (){
        super.init()
    }
    
    private static let allowedHttpMethods: Set =
        [HTTPMethod.GET, HTTPMethod.POST, HTTPMethod.PUT, HTTPMethod.DELETE]
    
    //HTTP Methods
    public class HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    /// Convert api params to query string.
    ///
    /// - Parameters:
    ///   - params: Dictionaryof params
    ///
    ///
    ///     Return query string
    ///
    private func queryString(_ params: [String: String]) -> String {
        var queryString = params.count > 0 ? "?" : ""
        queryString += paramString(encode(params))
        return queryString
    }
    
    private func encode (_ params: [String: Any]) -> [String: String] {
        let unencodedCharacterSet = CharacterSet(charactersIn: "-_.~").union(.alphanumerics)
        var encodedParams : [String: String] = [:]
        for (key, value) in params{
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: unencodedCharacterSet)!
            let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: unencodedCharacterSet)!
            encodedParams[encodedKey] = encodedValue
        }
        return encodedParams
    }
    
    private func paramString(_ params: [String: Any]) -> String {
        var postString = ""
        var first = true
        for (key, value) in params{
            if first {
                postString = key + "=" + "\(value)"
                first = false
            }else{
                postString = postString + "&" + key + "=" + "\(value)"
            }
        }
        return postString
    }
    
    fileprivate func getURL(path: String) -> String {
        return ROOT_API + path
    }
    
    /// Convert api response to json.
    ///
    /// - Parameters:
    ///   - response: Response data
    ///   - failure: NSError for invalid json
    ///
    ///     Return Json object
    ///
    open func getJSON( _ response: Data,
                       failure: @escaping (NSError) -> Void) -> Any? {
        
        do {
            let json = try JSONSerialization.jsonObject(with: response, options: [])
//            print(json)
            
            return json
        } catch let error as NSError {
            print(error.debugDescription)
            DispatchQueue.main.async(execute: {
                failure(error)
            })
            return nil
        }
        
    }
    
    /// provides all the facilities to call an HTTP API
    ///
    /// - Parameters:
    ///   - url: a url object of the api endpoint
    ///   - method: String of http method e.g. "GET"
    ///   - headers: `[String: String]`
    ///   - data: byte array passed into the body of the request
    ///   - failure: Error in case of failure
    ///   - success: Data and HTTPURLResponse in case of success
    fileprivate func call(_ url: URL,
                          method: String,
                          headers: [String : String],
                          data: Data?,
                          failure: @escaping ((Error) -> Void),
                          success: @escaping (Data, HTTPURLResponse) -> ()) {
        
        var request = URLRequest(url: url)
        assert(APIHelper.allowedHttpMethods.contains(method))
        request.httpMethod = method
        // add headers
        for (header, value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        if method == HTTPMethod.POST {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data
        
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            
            defer {
                self?.dataTask = nil
            }
            
            guard let data = data, error == nil else { // check for fundamental networking error
                failure(NSError(domain: error!.localizedDescription, code: -1, userInfo: nil))
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print("doing callback for the method")
                
                if let json = self?.getJSON(data, failure: failure) {
                    DispatchQueue.main.async(execute: {
                        
                        if let _ = json as? [[String:Any]] {
                            
                            success(data, httpResponse)
                        } else {
                            failure(NSError(domain: "Invalid json", code: -1, userInfo: nil))
                        }
                    })
                } else {
                    
                    success(data, httpResponse)
                }
            }
        }
        dataTask?.resume()
    }
    
    /// GET Request to API
    ///
    /// - Parameters:
    ///   - endpoint: String of enpoint * note: it cannot start with "/"
    ///   - headers: Map of strings for header name and values
    ///   - params: post body parameters as Map of Strings
    ///   - success: success callback
    ///   - failure: failure callback
    func get(_ endpoint: String, headers: [String: String] = [:],
             params: [String: String] = [:],
             failure: @escaping ((Error) -> Void),
             success: @escaping (Data, HTTPURLResponse) -> ()) {
        
        var qs = queryString(params)
        qs = getURL(path: endpoint + qs)
        print("Request: " + qs)
        
        if let url = URL(string: qs) {
            call(url,
                 method: HTTPMethod.GET,
                 headers: [:],
                 data: nil,
                 failure: failure,
                 success: success)
        } else {
            failure(NSError(domain: "Unsupported url.", code: 0, userInfo: nil))
        }
    }
}
