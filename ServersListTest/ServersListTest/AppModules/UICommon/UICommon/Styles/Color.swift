//
//  Color.swift
//  UICommon
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Foundation
import SwiftUI

public enum SLColor {
    case grayForeground, grayBackground, grayLight, gray, blue, white

    public var color: Color {
        switch self {
        case .grayBackground: return Color(red: 0.46, green: 0.46, blue: 0.5).opacity(0.12)
        case .grayForeground: return SLColor.gray.color.opacity(0.6)
        case .grayLight: return SLColor.gray.color.opacity(0.3)
        case .gray: return Color(red: 0.24, green: 0.24, blue: 0.26)
        case .blue: return Color(red: 0.27, green: 0.53, blue: 1)
        case .white: return .white
        }
    }
}
