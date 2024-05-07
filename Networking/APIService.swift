//
//  APIManager.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//
import Foundation
import UIKit

public enum Method: Int {
    case post,get,put,delete
}

extension Method {
    
    var name:String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        default:
            return "DELETE"
        }
    }
}

extension String {
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

struct File {
    let name: String?
    let filename: String?
    let data: Data?
    init(name: String?,filename: String?, data: Data?) {
        self.name       = name
        self.filename   = filename
        self.data       = data
    }
}

enum Result <T>{
    case Success(T)
    case Error(String)
}




public class APIService: NSObject {
    
    func startService(with method:Method,path:String,parameters:Dictionary<String,Any>?,files:Array<File>?, completion: @escaping (Result<Dictionary<String,Any>>) -> Void) {
        //print(parameters)
        guard var url = URL(string:Config.BASE_URL+path) else { return completion(.Error("  URL, we can't proceed.")) }
        print(url)

        /*if path == Config.urlMLWoundEvaluation{
            url = URL(string:Config.urlMLWoundEvaluation)!
            debugPrint(Config.urlMLWoundEvaluation)

        }*/
        let request = self.buildRequest(with: method, url: url, parameters: parameters, files: files)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            debugPrint("Response json ==== \(response)")
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Data not found."))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,AnyObject> {
                    debugPrint(json)
                    if let sttaus = json["statusCode"] as? Int,sttaus == 200 {
                        completion(.Success(json))
                    }else {
                        completion(.Error(json["message"] as? String ?? ""))
                    }
                }
            }catch let error {
                return completion(.Error(error.localizedDescription))
            }
            
        }
        
        task.resume()
        
    }
    func startServiceCodable(with method:Method,path:String,parameters:Dictionary<String,Any>?,files:Array<File>?, completion: @escaping (Result<Decodable>) -> Void) {
        //print(parameters)
        guard var url = URL(string:Config.BASE_URL+path) else { return completion(.Error("  URL, we can't proceed.")) }
        print(url)
        let request = self.buildRequest(with: method, url: url, parameters: parameters, files: files)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            debugPrint("Response json ==== \(response)")
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Data not found."))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,AnyObject> {
                    //debugPrint(json)
                    if let sttaus = json["statusCode"] as? Int,sttaus == 200 {
                        let genericMainModel = try JSONDecoder().decode(TrendGraphModel.self, from: data)
                        
                        completion(.Success(genericMainModel))
                    }else {
                        completion(.Error(json["message"] as? String ?? ""))
                    }
                }
            }catch let error {
                return completion(.Error(error.localizedDescription))
            }
            
        }
        
        task.resume()
        
    }
    func getDirectionService(with method:Method,path:String,parameters:Dictionary<String,Any>?,files:Array<File>?, completion: @escaping (Result<Dictionary<String,Any>>) -> Void) {
        guard var url = URL(string:path) else { return completion(.Error("  URL, we can't proceed.")) }
        let request = self.buildRequest(with: method, url: url, parameters: parameters, files: files)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //debugPrint("Response json ==== \(response)")
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Data not found."))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,AnyObject> {
                    //debugPrint(json)
                    
                    if let sttaus = json["status"] as? String,sttaus == "OK" {
                        completion(.Success(json))
                    }else {
                        completion(.Error(json["message"] as? String ?? ""))
                    }
                }
            }catch let error {
                return completion(.Error(error.localizedDescription))
            }
            
        }
        
        task.resume()
    }
    //Function for WoundAnalysis API
    func startServiceForWoundAnalysis(with method:Method,path:String,parameters:Dictionary<String,Any>?,files:Array<File>?, completion: @escaping (Result<Dictionary<String,Any>>) -> Void) {
        guard var url = URL(string:path) else { return completion(.Error("  URL, we can't proceed.")) }
        print(parameters)
        print(Config.BASE_URL+path)
        let request = self.buildRequest(with: method, url: url, parameters: parameters, files: files)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //debugPrint("Response json ==== \(response)")
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Data not found."))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,AnyObject> {
                    //debugPrint(json)
                    if let sttaus = json["statusCode"] as? Int,sttaus == 200 {
                        completion(.Success(json))
                    }else {
                        completion(.Error(json["message"] as? String ?? ""))
                    }
                }
            }catch let error {
                return completion(.Error(error.localizedDescription))
            }
            
        }
        
        task.resume()
        
    }
}

extension APIService {
    
    func buildRequest(with method:Method,url:URL,parameters:Dictionary<String,Any>?,files:Array<File>?) -> URLRequest {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "--\(boundary)--\r\n"
        
        var request:URLRequest? = nil
        
        switch method {
        case .get:
            if let params = parameters,params.count > 0 {
                let urlString: String = url.absoluteString
                let url : URL? = URL.init(string: urlString + queryItems(dictionary: parameters!))
                request = URLRequest(url: url!)
                
            } else {
                request = URLRequest(url: url)
            }
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .post:
            request = URLRequest(url: url)
            if let images = files,images.count > 0 {
                let boundary = "Boundary-\(UUID().uuidString)"
                let boundaryPrefix = "--\(boundary)\r\n"
                let boundarySuffix = "--\(boundary)--\r\n"
                request?.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
                let data = NSMutableData()
                if let params = parameters,params.count > 0{
                    for (key, value) in params {
                        data.append("--\(boundary)\r\n".nsdata)
                        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                        data.append("\((value as! Any))\r\n".nsdata)
                    }
                }
                for file in images {
                    data.append(boundaryPrefix.nsdata)
                    data.append("Content-Disposition: form-data; name=\"\(file.name!)\"; filename=\"\(NSString(string: file.filename!))\"\r\n\r\n".nsdata)
                    if let a = file.data {
                        data.append(a)
                        data.append("\r\n".nsdata)
                    } else {
                        debugPrint("Could not read file data")
                    }
                }
                data.append(boundarySuffix.nsdata)
                request?.httpBody = data as Data
            } else if let params = parameters,params.count > 0 {
                request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let  jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request?.httpBody = jsonData
            }
        default:
            request = URLRequest(url: url)
            break
        }
        let businessToken = UserDefaults.getBusinessToken() ?? ""
        request?.addValue(businessToken, forHTTPHeaderField: "businessToken")
        
        //Add Standard Time Offset
        let timezoneOffset = (CGFloat( NSTimeZone.system.secondsFromGMT())/3600.0) * 60.0
        let operatorSign = timezoneOffset > 0 ? "+" : ""
        let offset = "\(operatorSign)\(timezoneOffset)"
        request?.addValue(offset, forHTTPHeaderField: "StandardTime")
        //debugPrint("Time offset === \(operatorSign)\(timezoneOffset)")

        //Add Daylight Offset
        request?.addValue(offset, forHTTPHeaderField: "DayLightTime")

        //timezone
        var timezone: String {
            return TimeZone.current.localizedName(for:.standard,locale: .current) ?? ""
        }
        debugPrint("TimeZone \(timezone)")

        request?.addValue(timezone, forHTTPHeaderField: "Timezone")

        debugPrint("Access token \(UserDefaults.getAccessToken() ?? "")")
        if (UserDefaults.getAccessToken()) != nil{
            request?.addValue(UserDefaults.getAccessToken() ?? "", forHTTPHeaderField: "Authorization") ///ADDD "Bearer"
        }
        
        request?.httpMethod = method.name
        request?.timeoutInterval  = 180


        return request ?? URLRequest(url: url)
    }
    
    func queryItems(dictionary: [String:Any]) -> String {
        var components = URLComponents()
        //debugPrint(components.url!)
        components.queryItems = dictionary.map {
            URLQueryItem(name: $0, value: $1  as? String)
        }
        
        return (components.url?.absoluteString)!
    }

    func buildParams(parameters: Dictionary<String,Any>) -> String {
        var components: [(String, String)] = []
        for (key,value) in parameters {
            components += self.queryComponents(key, value)
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? Dictionary<String,Any> {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(string: key), escape(string: "\(value)"))])
        }
        
        return components
    }
    func escape(string: String) -> String {
        if let encodedString = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            return encodedString
        }
        return ""
    }
    
}
