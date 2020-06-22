//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation

enum Position: String, CaseIterable {
    case top, left, bottom, right
    case topLeft, topRight
    case bottomLeft, bottomRight
    case center
    
    var cardinal: String {
        switch self {
        case .top:
            return "North"
        case .left:
            return "West"
        case .bottom:
            return "South"
        case .right:
            return "East"
        case .topLeft:
            return "Northwest"
        case .topRight:
            return "Northeast"
        case .bottomLeft:
            return "Southwest"
        case .bottomRight:
            return "Southeast"
        case .center:
            return "Center"
        }
    }
}

extension Sequence where Element == Position {
    func formatted() -> String {
        map { $0.rawValue}.joined(separator: " | ")
    }
}
