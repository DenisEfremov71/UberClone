//
//  SideMenuOptionView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-12.
//

import SwiftUI

struct SideMenuOptionView: View {
    let viewModel: SideMenuOptionViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: viewModel.imageName)
                .font(.title2)
                .imageScale(.medium)
            Text(viewModel.title)
                .font(.system(size: 16, weight: .semibold))
            Spacer()
        }
    }
}

#Preview {
    SideMenuOptionView(viewModel: .trips)
}
