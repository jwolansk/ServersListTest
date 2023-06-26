//
//  TextInput.swift
//  UICommon
//
//  Created by Jakub Wolański on 23/06/2023.
//

import SwiftUI

public struct TextInputView: View {
    private let icon: Image?
    private let placeholder: String
    private let isSecure: Bool

    @Binding public var text: String
    @FocusState private var focused: Bool

    public init(icon: Image? = nil, placeholder: String = "", text: Binding<String>, isSecure: Bool = false) {
        self.icon = icon
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }

    public var body: some View {
        HStack {
            icon?
                .renderingMode(.template)
                .foregroundColor(focused ? SLColor.black.color : SLColor.grayForeground.color) // TODO: change icon tint based on focus
            if isSecure {
                SecureField(placeholder, text: $text, prompt: Text(placeholder).font(SLFont.inputPlaceholder.font))
                    .foregroundColor(focused ? SLColor.gray.color : SLColor.grayForeground.color)
                    .focused($focused)
            } else {
                TextField(placeholder, text: $text, prompt: Text(placeholder).font(SLFont.inputPlaceholder.font))
                    .foregroundColor(focused ? SLColor.gray.color : SLColor.grayForeground.color)
                    .focused($focused)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
        .frame(height: 40)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(SLColor.grayBackground.color)
        }

    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(icon: Image(systemName: "globe"), text: .constant("Text input"))
        TextInputView(icon: Image(systemName: "globe"), placeholder: "Placeholder", text: .constant(""), isSecure: true)
    }
}
