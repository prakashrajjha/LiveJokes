//
//  NetworkResponse.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import Foundation

public enum NetworkStatusCode: Int {
    case kSuccessCode     = 200
    case kBAD_URL_CODE    = 999
    case kNoInternetConn  = 5000
    case unknown = 0
}

public struct NetworkResponse {
    public private(set)var sucess: Bool
    public private(set)var data: Data?
    public private(set)var error: Error?
    public private(set)var sCode: NetworkStatusCode
    public private(set)var urlResposne:URLResponse?
}

extension NetworkResponse {
    static func log(_ obj: Any?) {
        #if DEBUG
        if obj != nil { print(obj!) }
        #endif
    }
    
    static var badURLResponse: NetworkResponse {
        return NetworkResponse(sucess: false, data: nil, error: nil, sCode: .kBAD_URL_CODE)
    }
    
    static func responseWith(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        let stCode = response?.statusCode ?? .unknown

        if let _ = error {
            return NetworkResponse(sucess: false, data: nil, error: error, sCode: stCode, urlResposne: response)
            // let mDict = ServiceManager.dictFrom(data: data)
            //self.handle(error: err, dict: mDict, code: stCode); return
        }
       
        return  NetworkResponse(sucess: true, data: data, error: error, sCode: stCode, urlResposne: response)
    }
    
   public var responseDict : Any? {
        if let mData = self.data  {
            var myDict : Any?
            do {
                myDict = try JSONSerialization.jsonObject(with: mData, options: JSONSerialization.ReadingOptions.mutableContainers)
                
            } catch { 
//                let str = String(data: mData, encoding: .utf8)
                NetworkResponse.log("JSON Processing Failed -> \(error)")
            }
            NetworkResponse.log(myDict)
            return myDict
        }
        return nil
    }
}


extension URLResponse {
    var statusCode: NetworkStatusCode {
        guard let mResponse = self as? HTTPURLResponse else { return .unknown }
        return NetworkStatusCode(rawValue: mResponse.statusCode) ?? .unknown
    }
    
    func log() {
        NetworkResponse.log("response -> \(self.description)")
    }
}
