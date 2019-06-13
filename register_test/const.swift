//
//  const.swift
//  register_test
//
//  Created by NAKAYAMA KEITO on 2019/06/12.
//  Copyright © 2019 NAKAYAMA KEITO. All rights reserved.
//

import Foundation

class const {

    static let url:String = "https://chibastusio-test-01.herokuapp.com/api/v1/sign_up"
    
    static let jsonStrRegsiterPost = """
        {
            "user": {
                "name": "a",
                "gender": 1,
                "area": "東京"
            }
        }
    """
    
    struct requestRegsiterPost: Codable {
        let user:user
        
    }
    struct user: Codable {
        var name:String
        var gender: Int
        var area: String
    }
    
    struct responseRegsiterPost: Codable {
        let id:Int
        let name: String
        let gender: Int
        let area: String
        let bio: String?
        let created_at: String
        let updated_at: String
        let token: String
        
    }
    
    
}


