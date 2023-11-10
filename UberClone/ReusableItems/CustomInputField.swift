//
//  CustomInputField.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-10.
//

import SwiftUI

struct CustomInputField: View {
    let title: String
    let placeholder: String
    var isSecureField = false
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // title
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .font(.footnote)

            // text field
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }




            // divider
            Rectangle()
                .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

#Preview {
    CustomInputField(title: "Title", placeholder: "Placeholder", text: .constant(""))
}
