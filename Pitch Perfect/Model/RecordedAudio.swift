//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Алексей Шпирко on 12/06/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation


class RecorderedAudio: NSObject {
    
    var filePathUrl: NSURL?
    private var title: String
    
    init(filePath: NSURL, title: String) {
        self.filePathUrl = filePath
        self.title = title
    }
}
