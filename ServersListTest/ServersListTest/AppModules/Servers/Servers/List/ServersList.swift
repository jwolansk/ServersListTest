//
//  ServersList.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import SwiftUI
import UICommon

public struct ServersList: View {
    @StateObject private var viewModel: ServersListViewModel
    @State var showSortActionSheet = false

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
        .navigationTitle("Testio.")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    showSortActionSheet = true
                                } label: {
                                    HStack {
                                        Image("sort")
                                        Text("Filter")
                                    }
                                }
                            }

                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button() {
                                    viewModel.logout()
                                } label: {
                                    HStack {
                                        Text("Logout")
                                        Image("logout")
                                    }
                                }
                            }
                        }

        .confirmationDialog("", isPresented: $showSortActionSheet) {
            Button("By distance") {
                viewModel.sortMethod = .distance
            }
            // Figma says this title should be black, but this is not defined in HIG, only descructive or cancel role have own style
            // TODO: implement custom action sheet with black text item
            Button("Alphabetical") {
                viewModel.sortMethod = .alphabetical
            }

        }
    }
}

struct ServersList_Previews: PreviewProvider {
    static var previews: some View {
        ServersList(viewModel: ServersListViewModel())
    }
}
