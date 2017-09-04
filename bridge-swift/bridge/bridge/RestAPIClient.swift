//
//  RestAPIClient.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 11/07/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//  http://www.disruptivewidgets.com
//

import Foundation

typealias ServiceResponse = (NSDictionary, NSError?) -> Void

public typealias CompletionCallback = (_ result: NSDictionary?, _ error: NSError?) -> Void

class RestAPIClient: NSObject {
    let app_delegate = UIApplication.shared.delegate as! AppDelegate

    static let sharedInstance = RestAPIClient()
    
    let base_url = "http://api.jamwithbridge.com" // ENDPOINT
    
    func authenticate(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/authenticate"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func authenticate_with_facebook(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/authenticate_with_facebook"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func create_user(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/users"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func update_user(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/users/" + "\(parameters["id"] as! Int)"
        self.submit_put_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    // MARK: USER
    func get_user_data(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_user_data/" + "\(parameters["user_id"] as! Int)"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    // MARK: STUDENT
    func create_student_profile(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/student_profiles"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func update_student_profile(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/student_profiles/" + "\(parameters["profile_id"] as! Int)"
        self.submit_put_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_student_profile(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/student_profiles/" + "\(parameters["student_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func retrieve_student_info(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/retrieve_student_record"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    // MARK: STUDENT
    
    // MARK: INSTRUCTOR
    func create_instructor_profile(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/instructor_profiles"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func update_instructor_profile(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/instructor_profiles/" + "\(parameters["profile_id"] as! Int)"
        self.submit_put_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_instructor_profile(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/instructor_profiles/" + "\(parameters["instructor_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func retrieve_instructor_info(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/retrieve_instructor_record"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    // MARK: INSTRUCTOR

    // MARK: MESSAGES
    func get_messages(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/users/\(parameters["user_id"] as! Int)/received_messages/sender/\(parameters["sender_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func create_message(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/messages"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_message_roster(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_message_roster/\(parameters["user_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    // MARK: MESSAGES
    
    // MARK: HISTORY
    func get_student_history(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_student_history/\(parameters["user_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_instructor_history(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_instructor_history/\(parameters["user_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    // MARK: HISTORY
    
    // MARK: LESSONS
    func create_lesson_request(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/lesson_requests"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func update_lesson_request(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/lesson_requests/\(parameters["lesson_request_id"] as! Int)"
        self.submit_put_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func approve_lesson_request(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/approve_lesson_request"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func decline_lesson_request(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/decline_lesson_request"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func create_lesson(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/lessons"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_lessons(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/lessons"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_lesson(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/lessons/" + "\(parameters["lesson_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func get_lesson_request(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/lesson_requests/" + "\(parameters["lesson_request_id"] as! Int)"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func retrieve_student_lessons(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/retrieve_student_lessons"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    func retrieve_instructor_lessons(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/retrieve_instructor_lessons"
        self.submit_post_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    // MARK: LESSONS
    
    func get_available_instructors(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_available_instructors"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func get_available_students(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_available_students"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func get_instructor_profile_settings(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_instructor_profile_settings"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func get_student_profile_settings(parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        let endpoint = self.base_url + "/get_student_profile_settings"
        self.submit_get_request(endpoint: endpoint, parameters: parameters, onCompletion: onCompletion)
    }
    
    func submit_post_request(endpoint: String, parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            RestAPIClient.sharedInstance.HTTPPostJSON(url: endpoint, data:data as NSData) { (response, error) -> Void in
                onCompletion(response as NSDictionary)
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    func submit_put_request(endpoint: String, parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            RestAPIClient.sharedInstance.HTTPPutJSON(url: endpoint, data:data as NSData) { (response, error) -> Void in
                onCompletion(response as NSDictionary)
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    func submit_get_request(endpoint: String, parameters: NSMutableDictionary, onCompletion: @escaping (NSDictionary) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            RestAPIClient.sharedInstance.HTTPGetJSON(url: endpoint, data:data as NSData) { (response, error) -> Void in
                onCompletion(response as NSDictionary)
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest, onCompletion: @escaping ServiceResponse) {
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                print("responseObject = \(responseObject)")
                
                onCompletion(responseObject, error as NSError?)
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                onCompletion([:], error)
            }
        })
        
        task.resume()
    }
    
    func HTTPPostJSON(url: String, data: NSData, onCompletion: @escaping ServiceResponse) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        if !self.app_delegate.me.auth_token.isEmpty {
            request.setValue(self.app_delegate.me.auth_token, forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, onCompletion: onCompletion)
    }
    
    func HTTPPutJSON(url: String, data: NSData, onCompletion: @escaping ServiceResponse) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.setValue(self.app_delegate.me.auth_token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "PUT"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, onCompletion: onCompletion)
    }
    
    func HTTPGetJSON(url: String, data: NSData, onCompletion: @escaping ServiceResponse) {
        
        let requestURL = NSURL(string: "\(url)")!
        
        let request = NSMutableURLRequest(url: requestURL as URL)
        
        request.setValue(self.app_delegate.me.auth_token, forHTTPHeaderField: "Authorization")
    
        request.httpMethod = "GET"
        HTTPsendRequest(request: request, onCompletion: onCompletion)
    }
    
//    // Convert from NSData to json object
//    func nsdataToJSON(data: NSData) -> AnyObject? {
//        do {
//            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject?
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }
//    // Convert from JSON to nsdata
//    func jsonToNSData(json: AnyObject) -> NSData?{
//        do {
//            return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as NSData?
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil;
//    }
    
    func makeHTTPGetRequest(path: String, parameters: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        
        let parameterString = parameters.stringFromHttpParameters()
        
        let requestURL = NSURL(string:"\(path)?\(parameterString)")!
        let request = NSMutableURLRequest(url: requestURL as URL)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                print("responseObject = \(responseObject)")
                
                onCompletion(responseObject, error as NSError?)
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                onCompletion([:], error)
            }
        })
        task.resume()
    }
//    func makeHTTPPostRequest(path: String, parameters: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
//        //var err: NSError?
//        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
//        // Set the method to POST
//        request.httpMethod = "POST"
//        
//        // Set the POST body for the request
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            
//            let session = URLSession.shared
//            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//                //                let json:JSON = JSON(data: data!)
//                do {
//                    let responseObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//                    
//                    print("responseObject: \(responseObject)")
//
//                    onCompletion(responseObject, error as NSError?)
//                    
//                } catch let error as NSError {
//                    print("error: \(error.localizedDescription)")
//                    onCompletion([:], error)
//                }
//            })
//            task.resume()
//        } catch {
//            print("error:\(error)")
//        }
//    }
}
extension String {
    
    /// Percent escape value to be added to a URL query value as specified in RFC 3986
    ///
    /// This percent-escapes all characters besize the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Return precent escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters:characterSet as CharacterSet)
    }
}
extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
