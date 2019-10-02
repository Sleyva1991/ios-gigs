//
//  GigsController.swift
//  Gigs
//
//  Created by Steven Leyva on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class GigsController {
    
    var bearer: Bearer?
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp (with user: User, completion: @escaping (Error?) -> Void) {
        
        // Build the URL
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        // Build the Request
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the request the API that the body is in JSON format
        request.setValue("appication/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
        }
        
        // perform the request (data task)
        
        URLSession.shared.dataTask(with: request) { (data, respone, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            if let response = respone as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "" , code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            completion(nil)
            }.resume()

    }
    
    // Create function for sign in
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            guard let data = data else {
                NSLog("No data return from data task")
                let noDataError = NSError(domain: "", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding the bear token: \(error)")
                completion(error)
            }
            
            completion(nil)
            }.resume()
    }
}
