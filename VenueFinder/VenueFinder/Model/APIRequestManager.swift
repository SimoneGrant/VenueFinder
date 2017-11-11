//
//  APIRequestManager.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let sharedManager = APIRequestManager()
    private init () {}
    
    func fetchFSData(endPoint: String, _ completionHandler: @escaping (Response) -> ()) {
        guard let url = URL(string: endPoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            
            do {
                let venue = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(venue)
                })
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func fetchVGData(endPoint: String, _ completionHandler: @escaping (EntryItems) -> ()) {
        guard let url = URL(string: endPoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            
            do {
                let venue = try JSONDecoder().decode(EntryItems.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(venue)
                })
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func fetchYelpRestaurants(endPoint: String, _ completionHandler: @escaping (RestaurantDetails) -> ()) {
        guard let url = URL(string: endPoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Auth.init().yelpToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            
            do {
                let venue = try JSONDecoder().decode(RestaurantDetails.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(venue)
                })
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func fetchYelpBusiness(endPoint: String, _ completionHandler: @escaping (VenueDetails) -> ()) {
        guard let url = URL(string: endPoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Auth.init().yelpToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            
            do {
                let venue = try JSONDecoder().decode(VenueDetails.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(venue)
                })
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func fetchYelpReviews(endPoint: String, _ completionHandler: @escaping (Reviews) -> ()) {
        guard let url = URL(string: endPoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Auth.init().yelpToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            
            do {
                let venue = try JSONDecoder().decode(Reviews.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(venue)
                })
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    //To build the yelp client, I need to create a url request "get" method in order to put the token in the url header
    //need to refactor so that token is not hard coded
    func fetchYelpDetails(endPoint: String, _ completionHandler: @escaping (Businesses) -> ()) {
        guard let url = URL(string: endPoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Auth.init().yelpToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            
            do {
                let venue = try JSONDecoder().decode(Businesses.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(venue)
                })
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
}

/* **********IMPLEMENT TO REFRESH TOKEN*************
 //according to documentation, tokens are due to expire in 2038
 //can refactor this section into a failsafe function in case of token issues
 
 let clientId = Auth.init().clientID
 let clientSecret = Auth.init().clientSecret
 let tokenURL = "https://api.yelp.com/oauth2/token"
 let grantType = "client_credentials"
 
 let url = URL(string: tokenURL)
 let session = URLSession(configuration: .default)
 let request = URLRequest(URL: url)
 request.httpMethod = "POST"
 request.httpShouldHandleCookies = true
 request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
 
 let postString = "client_id=" + clientId + "&client_secret=" + clientSecret + "&grant_type=" + grantType
 request.httpBody = postString.dataUsingEncoding(UTF8)
 
 let task: URLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
     if let data = data {
         let response = NSString(data: data, encoding: UTF8)
         print(response)
         //response.accesstoken for new apirequest
     }
 }
 task.resume()
 
 */




