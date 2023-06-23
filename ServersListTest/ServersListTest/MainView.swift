//
//  MainView.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("splash")
                .resizable()
                .frame(width: 430, height: 378)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
        .overlay() {
            Image("logo")
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
