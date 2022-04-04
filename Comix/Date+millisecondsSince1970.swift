//
//  Date+millisecondsSince1970.swift
//  Comix
//
//  Created by Scott Lewis on 4/3/22.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
