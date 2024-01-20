//
//  TripAcceptedView.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-20.
//

import SwiftUI

struct TripAcceptedView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            // pickup info view
            VStack {
                HStack {
                    Text("Meet your driver at Apple Campus for your trip to Starbucks")
                        .font(.body)
                        .frame(height: 44)
                        .padding(.trailing)
                    Spacer()
                    VStack {
                        Text("10")
                            .bold()
                        Text("min")
                            .bold()
                    }
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                }
                .padding()

                Divider()
            }

            // driver info view
            VStack {
                HStack {
                    Image("male-profile-photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Kevin Smith")
                            .fontWeight(.bold)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(.systemYellow))
                                .imageScale(.small)
                            Text("4.8")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()

                    // driver vehicle info
                    VStack(alignment: .center) {
                        Image("uber-x")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 64)
                        HStack {
                            Text("Mercedes")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            Text("050SBN")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(width: 160)
                        .padding(.bottom)
                    }
                }
                Divider()
            }
            .padding()

            Button {
                print("DEBUG: Cancel trip")
            } label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.top, 6)

        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripAcceptedView()
}