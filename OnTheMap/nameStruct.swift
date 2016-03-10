//
//  File.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 3/9/16.
//  Copyright © 2016 pritesh kadiwala. All rights reserved.
//

import Foundation



struct userData{
    var userID: String
    init(userID: String){
        self.userID = userID
    }
    static func getID(id: String) -> String {
        var setID = userData?()?.userID
        setID = id
        
        return setID!
    }
    
}