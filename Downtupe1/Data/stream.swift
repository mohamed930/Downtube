//
//  stream.swift
//  Downtupe1
//
//  Created by Mohamed Ali on 5/2/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import Foundation

class stream : Decodable {
    var url:String?
    
    enum CodingKeys : String, CodingKey {
        case url = "url"
    }
}
