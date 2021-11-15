//
//  SwiftUIView.swift
//  
//
//  Created by Ralf Ebert on 15.11.21.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let reloadAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            Text(error.localizedDescription)
            if let reloadAction = reloadAction {
                Button(
                    action: reloadAction,
                    label: {
                        Image(systemName: "arrow.clockwise")
                    }
                )
            }
        }
    }
}
