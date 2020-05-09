//
//  URLDecoder.swift
//  Downtupe1
//
//  Created by Mohamed Ali on 5/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class url: Decodable {
    
    var statue:Bool?
    var uploader:String?
    var title:String?
    var thumbnil:String?
    var Streams:[stream]?
    
    enum CodingKeys : String, CodingKey {
        case statue = "status"
        case uploader = "uploader"
        case title = "title"
        case thumbnil = "thumbnail"
        case Streams = "streams"
    }
}
