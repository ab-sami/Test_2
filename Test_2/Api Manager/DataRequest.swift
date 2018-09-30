//
//  DataRequest.swift
//  Tsetatonsisith
//
//  Created by Abdul Sami on 20/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class DataRequest : URLRequestConvertible {
    
    public static let DefaultCachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
    public static let DefaultTimeOutIterval:TimeInterval = 60
    
    public var url:String
    public var method:HTTPMethod
    public var forceNetwork:Bool
    public var headers:[String : String]
    public var data:Data?
    
    public var response:DataResponse?
    
    convenience init(url:String, method: HTTPMethod = .get, forceNetwork:Bool = false, data:Data? = nil, headers: [String : String]? = nil) {
        self.init(url: url, method: method, forceNetwork: forceNetwork, rawData: data, headers: headers)
    }
    
    private init(url:String, method: HTTPMethod = .get, forceNetwork:Bool = false, rawData:Data? = nil, headers: [String : String]? = nil) {
        self.url = url
        self.method = method
        self.headers = headers ?? [:]
        self.data = rawData
        self.forceNetwork = forceNetwork
    }

    public func addQueryParameter(key:String?, value:String?) {
        guard let value = value else {
            return
        }
        
        guard let key = key else {
            return
        }
        
        let queryString = key + "=" + value.escape()
        url = url + (url.contains("?") ? "&" : "?") + queryString
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        guard let url = URL(string: self.url) else {
            throw AFError.invalidURL(url: self.url)
        }
        
        let policy = (forceNetwork || method != .get) ? URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData : URLRequest.CachePolicy.returnCacheDataElseLoad
        
        guard var urlRequest = try? URLRequest(url: url, method: method) else {
            throw AFError.invalidURL(url: self.url)
        }
        
        urlRequest.cachePolicy = policy
        urlRequest.timeoutInterval = DataRequest.DefaultTimeOutIterval
        
        if let data = self.data {
            urlRequest.httpBody = data
        }
        
        headers += defaultHeaders
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
    
    private var defaultHeaders: [String : String] {
        return ["Accept" : "application/json",
                "Content-Type" : "application/json"]
    }
}
