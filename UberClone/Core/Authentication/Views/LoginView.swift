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
                    VStack(alignment: .leading, spacing: 12) {
                        // title
                        Text("Email Address")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.footnote)

                        // text field
                        TextField("name@example.com", text: $email)
                            .foregroundColor(.white)


                        // divider
                        Rectangle()
                            .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    // input field 2
                    VStack(alignment: .leading, spacing: 12) {
                        // title
                        Text("Password")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.footnote)

                        // text field
                        TextField("Enter your password", text: $password)
                            .foregroundColor(.white)


                        // divider
                        Rectangle()
                            .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

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
                    HStack(spacing: 24) {
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
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
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
