//
//  RedAPI.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]

class RedAPI {
    
    static let shared = RedAPI()
    let kAuthURL = "https://ssl.reddit.com/api/v1/authorize?client_id=sog6MOSPP1E2EQ&response_type=code&state=TEST&redirect_uri=autoscrollRed://blank&duration=permanent&scope=read"
    private let kAccessTokenEndPoint = "https://www.reddit.com/api/v1/access_token"
    private let kClientID = "sog6MOSPP1E2EQ"
    private let kRedditAPIEndPoint = "https://oauth.reddit.com"
    
    private var kAccessToken = ""
    private var kRefreshToken = ""
    private var isAccessTokenSet = false
    private var isRefreshTokenSet = false

    func getCodeFrom(url: URL) -> String? {
        guard let queryParams = url.query?.components(separatedBy: "&")
            else {
                print("Error @ queryParams")
                return nil
        }
        
        var codeIndex = 0
        for index in 0..<queryParams.count {
            if (queryParams[index].contains("code=")) {
                codeIndex = index
            }
        }
        let codeString = queryParams[codeIndex].replacingOccurrences(of: "code=", with: "")
        return codeString
        
    }
    
    func getAccessToken(code: String, callback: @escaping (JSON) -> ()) {
        let username = kClientID
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let url = URL(string: kAccessTokenEndPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let myParams = "grant_type=authorization_code&code=\(code)&redirect_uri=autoscrollRed://blank"
        let postData = myParams.data(using: .utf8, allowLossyConversion: true)
        request.httpBody = postData

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (returnData, response, error) -> Void in
            do {
                guard let data = returnData else {
                    print("ERROR: Returned data is nil")
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? JSON else {
                    print("ERROR: JSON is nil")
                    return
                }
                callback(json)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }).resume()
    }
    
    func getHotListing(callback: @escaping (JSON) -> ()) {
        let url = URL(string: kRedditAPIEndPoint + "/hot?limit=3")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bearer \(kAccessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (returnData, response, error) -> Void in
            do {
                guard let data = returnData else {
                    print("ERROR: Returned data is nil")
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? JSON else {
                    print("ERROR: JSON is nil")
                    return
                }
                
                callback(json)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }).resume()
    }
    
    func getPostsFromListing(listing: JSON) -> [RPost]? {
        guard let data = listing["data"] as? JSON else {
            return nil;
        }
        guard let children = data["children"] as? [JSON] else {
            return nil;
        }
        
        var posts = [RPost]()
        for child in children {
            if let post = child["data"] as? JSON {
                posts.append(RPost(post))
            }
        }
        return posts
    }
    
    func setAccessToken(_ json: JSON) {
        guard let token = json["access_token"] as? String
        else {
            print("ERROR: JSON doesn't contain access token")
            return
        }
        
        kAccessToken = token
        isAccessTokenSet = true
    }
    
    func setRefreshToken(_ json: JSON) {
        guard let token = json["refresh_token"] as? String
            else {
                print("ERROR: JSON doesn't contain access token")
                return
        }
        
        kRefreshToken = token
        isRefreshTokenSet = true
    }
    
}
