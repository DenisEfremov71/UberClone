//
//  RegistrationView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-10.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authenticationVM: AuthenticationViewModel

    private var credentialsValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }

                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)

                VStack {
                    VStack(spacing: 56) {
                        CustomInputField(
                            title: "Full Name",
                            placeholder: "Enter your name",
                            text: $fullname
                        )

                        CustomInputField(
                            title: "Email Address",
                            placeholder: "Enter your email",
                            text: $email
                        )

                        CustomInputField(
                            title: "Create Password",
                            placeholder: "Enter your password",
                            isSecureField: true,
                            text: $password
                        )
                    }
                    .padding(.vertical, 32)

                    Button {
                        authenticationVM.registerUser(
                            withEmail: email,
                            password: password,
                            fullname: fullname
                        )
                    } label: {
                        HStack {
                            Text("Sign Up")
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .disabled(!credentialsValid)
                }

                Spacer()

            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    RegistrationView()
}
