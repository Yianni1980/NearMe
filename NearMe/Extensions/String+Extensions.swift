//
//  String+Extensions.swift
//  NearMe
//
//  Created by ioannis on 24/1/23.
//

import Foundation

extension String {
    
    var formatPhoneForCallL:String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
        
    }
}
