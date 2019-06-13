//
//  HttpClient.swift
//  register_test
//
//  Created by NAKAYAMA KEITO on 2019/06/12.
//  Copyright © 2019 NAKAYAMA KEITO. All rights reserved.
//

import Foundation

class HttpClient {
    func get() {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        let url: URL = URL(string: "http://example.com")!
        
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            // do something
        })
    }
    
    func post(url:String, body: String) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        let url: URL = URL(string: url)!
        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = body.data(using: .utf8)
        
        let task = session.dataTask(with: req, completionHandler: { (data, response, error) in
            // do something
            print(response!)
            
            guard let data = data, let urlResponse = response as? HTTPURLResponse else {
                return
            }
            if (urlResponse.statusCode == 200) {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(const.responseRegsiterPost.self, from: data)
                    print(response)
                } catch {
                    print(error)
                }
            }else {
                print("error")
            }
    
        })
        task.resume()
    }
}
