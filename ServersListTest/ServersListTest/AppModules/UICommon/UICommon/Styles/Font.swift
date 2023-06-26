//
//  Font.swift
//  UICommon
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Foundation
import SwiftUI

public enum SLFont {
    case inputText, inputPlaceholder, caption

    public var font: Font {
        switch self {
        case .inputPlaceholder, .inputText: return Font.custom("SF Pro Text", size: 17)
        case .caption: return Font.custom("SF Pro Text", size: 13)
        }
    }
}
