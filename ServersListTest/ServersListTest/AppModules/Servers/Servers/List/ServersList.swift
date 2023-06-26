//
//  ServersList.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import SwiftUI

public struct ServersList: View {
    @StateObject private var viewModel: ServersListViewModel

    public init(viewModel: ServersListViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        List(viewModel.servers) { server in
            HStack {
                Text(server.name)
                Spacer()
                Text("\(server.distance)")
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct ServersList_Previews: PreviewProvider {
    static var previews: some View {
        ServersList(viewModel: ServersListViewModel())
    }
}
