//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.url)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName:String, completion: @escaping ((Bool) ->Void)) {
        let urlString = "\(Secrets.url)/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let session = URLSession.shared
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
             let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 204 {
                completion(true)
            }else{
                completion(false)
            }
        }
        task.resume()
     }
    
    class func starRepository(named:String, completion:@escaping (() -> Void)) {
        
        let urlString = "\(Secrets.url)/user/starred/\(named)?access_token=\(Secrets.personalAccessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let session = URLSession.shared
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "PUT"
        let task = session.dataTask(with: request) { (data, response, error) in
            completion()
                    }
        task.resume()
        
    }
    
    class func unstarRepository(named:String, completion:@escaping (() -> Void)) {
        
        let urlString = "\(Secrets.url)/user/starred/\(named)?access_token=\(Secrets.personalAccessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let session = URLSession.shared
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "DELETE"
        let task = session.dataTask(with: request) { (data, response, error) in
            completion()
                    }
        task.resume()
        
    }

}

