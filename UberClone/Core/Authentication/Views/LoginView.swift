//
//  LoginView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-10.
//

import SwiftUI

struct LoginView: View {


    var body: some View {
        @State var email = ""
        @State var password = ""

        ZStack {
            Color(.black)
                .ignoresSafeArea()

            VStack {

                // image and title
                VStack(spacing: 16) {
                    // image
                    Image("uber-app-icon")
                        .resizable()
                        .frame(width: 150, height: 150)
                    // title
                    Text("UBER")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }

                // input fields
                VStack(spacing: 24) {
                    // input field 1
                    CustomInputField(
                        title: "Email",
                        placeholder: "name@example.com",
                        text: $email
                    )

                    // input field 2
                    CustomInputField(
                        title: "Password",
                        placeholder: "Enter your password",
                        isSecureField: true,
                        text: $password
                    )

                    Button {

                    } label: {
                        Text("Forgot password?")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                }
                .padding(.top, 12)

                // social sign in view
                VStack {
                    // dividers + text
                    HStack(spacing: 24) {
                        Rectangle()
                            .frame(width: 76, height: 1)
                            .foregroundColor(.white)
                            .opacity(0.5)

                        Text("Sign in with social")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)

                        Rectangle()
                            .frame(width: 76, height: 1)
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }

                    // social media sign up buttons
                    HStack(spacing: 32) {
                        Button {

                        } label: {
                            Image("facebook-sign-in-icon")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }

                        Button {

                        } label: {
                            Image("google-sign-in-icon")
                                .resizable()
                                .frame(width: 44, height: 44)
                        }
                    }
                }
                .padding(.top, 24)

                Spacer()

                // sign in button
                Button {

                } label: {
                    HStack {
                        Text("SIGN IN")
                            .foregroundColor(.black)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                }
                .background(.white)
                .cornerRadius(10)

                Spacer()

                // sign up button
                Button {

                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                        Text("Sign Up")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
