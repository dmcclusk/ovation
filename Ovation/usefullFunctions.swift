//
//  usefullFunctions.swift
//  Ovation
//
//  Created by Dermot McCluskey on 08/06/2019.
//  Copyright © 2019 Dermot McCluskey. All rights reserved.
//

import Foundation

class UsefullFunctions {
    
    static func Split(line: String, with sep: String) -> String{
        
        var data = line.components(separatedBy: sep)
        if (data.count > 0) {
            return data[0]
        }
        return line
    }
    
    //takes a comma separated string and returns an array of strings
    static func SplitAndReturnAll(line: String, with sep: String) -> [String] {
        var strArray = [String]()
        let data = line.components(separatedBy: sep)
        if data.count > 0 {
            for indi in data {
                strArray.append("\(indi.trim())\n")
            }
        }
        else {
            strArray.append(line)
        }
        return strArray
    }
    
    static func SplitFilename(path str: String) -> (String) {
        let url = URL(fileURLWithPath: str)
        return ("\(url.deletingPathExtension().lastPathComponent).\(url.pathExtension)")
    }
    
}
