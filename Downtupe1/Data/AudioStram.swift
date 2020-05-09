//
//  AudioStram.swift
//  Downtupe1
//
//  Created by Mohamed Ali on 5/7/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import Foundation

class AudioStream: Decodable {
    let url: String?
    
    enum CodingKeys : String, CodingKey {
        case url = "url"
    }
}
