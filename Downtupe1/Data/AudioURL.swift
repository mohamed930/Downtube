//
//  AudioURL.swift
//  Downtupe1
//
//  Created by Mohamed Ali on 5/7/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import Foundation

class AudioURL1: Decodable {
    
    let title : String?
    let uploader: String?
    let status: Bool?
    let thumbnail: String?
    let streams: [AudioStream]?
    
    enum CodingKeys : String, CodingKey {
        case status = "status"
        case title = "title"
        case uploader = "uploader"
        case streams = "streams"
        case thumbnail = "thumbnail"
    }
}
