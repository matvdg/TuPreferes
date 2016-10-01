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
                let err = NSError(domain: "HTTP Error" , code: statusCode, userInfo: nil)
                callback(nil, err)
                return
            }
            callback(data,nil)
            
        }) 
        task.resume()
    }
    
}

protocol HttpClient {
    func get(_ url: URL, callback: @escaping (Data?, NSError?)->() )
}
