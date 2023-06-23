//
//  Button.swift
//  UICommon
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Foundation
import SwiftUI

public enum SLButton {
    public struct Primary: View {
        private let title: String
        private let action: () -> Void

        public var body: some View {
            SLButton.Colored(title: title,
                             backgroundColor: .blue,
                             textColor: .white,
                             action: action)
        }

        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }

    public struct Colored: View {
        private let title: String
        private let backgroundColor: Color
        private let textColor: Color
        private let action: () -> Void

        private var minHeight: CGFloat { 40 }

        private var radius: CGFloat { 10 }

        public var body: some View {
            Button(action: action) {
                Text(title)
                    .foregroundColor(textColor)
                    .padding(.horizontal, 18)
                    .frame(maxWidth: .infinity, minHeight: minHeight)
                    .background(backgroundColor)
                    .cornerRadius(radius)
            }
        }
        public init(title: String, backgroundColor: SLColor, textColor: SLColor, action: @escaping () -> Void) {
            self.title = title
            self.backgroundColor = backgroundColor.color
            self.textColor = textColor.color
            self.action = action
        }

    }
}
