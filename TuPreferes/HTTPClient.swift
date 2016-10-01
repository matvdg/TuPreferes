//
//  HTTPClient.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation

class DefaultHTTPClient: HttpClient {

    
    func get(_ url: URL, callback: @escaping (Data?, NSError?)->() ) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                callback(nil, error as NSError?)
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode != 200 {
                let err = NSError(domain: "HTTP Error", code: statusCode, userInfo: nil)
                callback(nil, err)
                return
            }
            
            callback(data,nil)
            
        }) 
        task.resume()
    }
    
    func postJson(_ url: URL, data: Dictionary<String, Any>?, callback: @escaping (Data?, NSError?)->() ) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            
            // create post request
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    callback(nil, error as NSError?)
                    return
                }
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                if statusCode >= 300 {
                    let err = NSError(domain: "HTTP Error", code: statusCode, userInfo: nil)
                    callback(nil, err)
                    return
                }
                
                callback(data, nil)
            }
            
            task.resume()
        } catch {
            callback(nil, error as NSError?)
        }
    }
    
}

protocol HttpClient {
    func get(_ url: URL, callback: @escaping (Data?, NSError?)->() )
    func postJson(_ url: URL, data: Dictionary<String, Any>?, callback: @escaping (Data?, NSError?)->() )
}
