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
    
    private var accessToken: String?
    private var refreshToken: String?
    private let kAccessToken = "AccessToken"
    private let kRefreshToken = "RefreshToken"
    
    
    // MARK: Get Access from Reddit
    
    func checkCurrentAccessToken() {
        getTokens()
        
    }

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
    
    func getAccessToken(code: String, callback: @escaping (Bool) -> ()) {
        let loginString = String(format: "%@:%@", kClientID, "")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let url = URL(string: kAccessTokenEndPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let myParams = "grant_type=authorization_code&code=\(code)&redirect_uri=autoscrollRed://blank&duration=permanent"
        let postData = myParams.data(using: .utf8, allowLossyConversion: true)
        request.httpBody = postData

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (returnData, response, error) -> Void in
            do {
                guard let data = returnData else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? JSON else { return }
                
                if (RedAPI.shared.setAccessToken(json) &&
                    RedAPI.shared.setRefreshToken(json)) {
                    callback(true)
                } else {
                    callback(false)
                    print("ERROR: Invalid JSON for access token")
                }
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }).resume()
    }
    
    func refreshAccessToken(callback: @escaping (Bool) -> ()) {
        getTokens()
        if (refreshToken == nil) {
            callback(false)
            return
        }
        let loginString = String(format: "%@:%@", kClientID, "")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let url = URL(string: kAccessTokenEndPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let myParams = "grant_type=refresh_token&refresh_token=\(refreshToken!)"
        let postData = myParams.data(using: .utf8, allowLossyConversion: true)
        request.httpBody = postData
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (returnData, response, error) -> Void in
            do {
                guard let data = returnData else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? JSON else { return }
                
                if (RedAPI.shared.setAccessToken(json)) {
                    callback(true)
                } else {
                    print("ERROR: Invalid JSON for access token")
                    callback(false)
                }

            } catch let error as NSError {
                print(error.debugDescription)
            }
        }).resume()
    }
    
    // MARK: Access tokens <-> persistent memory
    
    func getTokens() {
        accessToken = UserDefaults.standard.string(forKey: kAccessToken)
        refreshToken = UserDefaults.standard.string(forKey: kRefreshToken)
    }
    
    private func setAccessToken(_ json: JSON) -> Bool {
        guard let token = json["access_token"] as? String
            else {
                print("ERROR: JSON doesn't contain access token")
                return false
        }
        
        accessToken = token
        UserDefaults.standard.set(accessToken, forKey: kAccessToken)
        return true
    }
    
    private func setRefreshToken(_ json: JSON) -> Bool {
        guard let token = json["refresh_token"] as? String
            else {
                print("ERROR: JSON doesn't contain refresh token")
                return false
        }
        
        refreshToken = token
        UserDefaults.standard.set(refreshToken, forKey: kRefreshToken)
        return true
    }
    
    // MARK: Get Listing/Posts
    
    func getListing(_ listing: String, count: Int, callback: @escaping (JSON) -> ()) {
        if (accessToken == nil) {
            return 
        }
        let url = URL(string: kRedditAPIEndPoint + "\(listing)?limit=\(count)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
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
    
    func getPosts(_ listing: JSON) -> [RPost]? {
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
    
    func getPostsFromListing(_ listing: String, count: Int, callback: @escaping ([RPost]?) -> ()) {
        getListing(listing, count: count) { (json) in
            if let posts = self.getPosts(json) {
                callback(posts)
            } else {
                callback(nil)
            }
        }
    }
    
    
    
}

enum Listings {
    static let hot = "/hot"
    static let new = "/new"
    static let random = "/random"
}

