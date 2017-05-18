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
    private let apiEndPoint = "https://api.fixer.io/latest"

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
}
