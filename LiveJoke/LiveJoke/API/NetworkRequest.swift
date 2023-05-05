//
//  NetworkRequest.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import Foundation

typealias kJSONDictionary = [String: Any]
typealias KHTTPHeaders = [String: String]
typealias ServiceCompletion = (_ response: NetworkResponse) -> Swift.Void

enum NetworkReqType: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

struct NetworkRequest {
    private(set) var type: NetworkReqType
    private(set) var path: String
    private(set) var param: kJSONDictionary?
    public private(set) var headers: KHTTPHeaders?
    private(set) var reqTimeout: Double
    private(set) var respTimeout: Double
    
    init(type: NetworkReqType = .get,
         path: String,
         param: kJSONDictionary? = nil,
         headers: KHTTPHeaders? = nil,
         reqTimeout: Double = 60,
         respTimeout: Double = 60) {
        self.type = type
        self.path = path
        self.param = param
        self.headers = headers
        self.reqTimeout = reqTimeout
        self.respTimeout = respTimeout
    }
}

extension NetworkRequest {
     func execute(completion : @escaping ServiceCompletion) {
        guard let urlRequest = self.urlRequest else { completion(NetworkResponse.badURLResponse); return }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(self.reqTimeout)
        config.timeoutIntervalForResource = TimeInterval(self.respTimeout)
        
         let session = URLSession.init(configuration: .default)
        session.configuration.timeoutIntervalForRequest = TimeInterval(self.reqTimeout)
        session.configuration.timeoutIntervalForResource = TimeInterval(self.respTimeout)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            NetworkResponse.log("Request -> \(urlRequest.cURL(pretty: true))")
                        
            // Convert to a string and print
             if let jsonData  = data, let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                 NetworkResponse.log(JSONString)
            }
            completion(NetworkResponse.responseWith(data: data, response: response, error: error))
        }
        task.resume()
    }
    
}

extension NetworkRequest {
    var urlRequest: URLRequest? {
        guard let aUrl = URL(string: path) else { return nil }
        
        let request         = NSMutableURLRequest(url: aUrl)
        request.httpMethod  = type.rawValue

        if let mHeader = headers {
            for hEntity in mHeader {
                request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
            }
        }
        return self.appendParamsTo(request: request) as URLRequest
    }
    
    func appendParamsTo(request: NSMutableURLRequest) -> NSMutableURLRequest {
        guard let aParam = param else { return request }
        if type == .get { return request }
        request.httpBody = try! JSONSerialization.data(withJSONObject: aParam, options: [])
        return request
    }
}



extension URLRequest {
    public func cURL(pretty: Bool = false) -> String {
        #if DEBUG
        var data : String = ""
        let complement = pretty ? "\\\n" : ""
        let method = "-X \(self.httpMethod ?? "GET") \(complement)"
        let pStr = self.url?.absoluteString ?? ""
        let url = "\"" + pStr + "\""
        
        var header = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += "-H \"\(key): \(value)\" \(complement)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data:bodyData, encoding:.utf8) {
            data = "-d \"\(bodyString)\" \(complement)"
        }
        
        let command = "curl -i " + complement + method + header + data + url
        
        return command

        #else
        return ""
        #endif
    }
}
