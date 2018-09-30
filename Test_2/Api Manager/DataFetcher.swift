//
//  DataFetcher.swift
//  Tsetatonsisith
//
//  Created by Abdul Sami on 20/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

internal class DataFetcher {
    
    public init() {
    }
    
    //DataRequest->Decodable
    internal func run<T:Decodable> (_ request:DataRequest, base64Encoded:Bool=false, onSuccess: @escaping (T)->(), onFailure: @escaping ErrorCall) {

        self.run(request, base64Encoded:base64Encoded, onSuccess: { (data:Data) in
            do {
                let decodable = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodable)
            }
            catch { (error)
                #if DEBUG
                let string = String(data: data, encoding: String.Encoding.utf8) ?? "No decodable response received"
                print("❗️Request: \(request.url)")
                print("❗️Response: \(string)")
                print("❗️Decoding Error Occurred!" )
                print(error)
                #endif
                return onFailure(error)
            }

        }, onFailure: onFailure)
    }
    
    //DataRequest->RawData
    internal func run(_ request:DataRequest, base64Encoded:Bool=false, onSuccess: @escaping (Data)->(), onFailure: @escaping ErrorCall) {

        Alamofire.request(request).responseData { (response) in

            guard let httpResponse = response.response else {
                if let error = response.result.error ?? response.error {
                    return onFailure(error)
                }
                return onFailure(nil)
            }
            
            let dataResponse = DataResponse(statusCode: httpResponse.statusCode, headers: httpResponse.allHeaderFields)
            request.response = dataResponse
            
             //Success
            if let data = response.data, let _ = request.urlRequest {
                onSuccess(data)
            }
        }
    }
}
