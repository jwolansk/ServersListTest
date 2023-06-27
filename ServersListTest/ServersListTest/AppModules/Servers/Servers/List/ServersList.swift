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
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 0.2)
                .background(SLColor.white.color)

            List() {
                Section(content: {
                    ForEach(viewModel.servers) { server in
                        HStack {
                            Text(server.name)
                            Spacer()
                            Text("\(server.distance) km")
                                .frame(width: 80, alignment: .leading)
                        }
                    }
                }, header: {
                    HStack {
                        Text("SERVER")
                        Spacer()
                        Text("DISTANCE")
                            .frame(width: 80, alignment: .leading)
                    }
                })
            }
            .listStyle(.grouped)
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
                .disabled(viewModel.sortMethod == .distance)
                // Figma says this title should be black, but this is not defined in HIG, only descructive or cancel role have own style
                Button("Alphabetical") {
                    viewModel.sortMethod = .alphabetical
                }
                .disabled(viewModel.sortMethod == .alphabetical)

            }
        }
    }
}

struct ServersList_Previews: PreviewProvider {
    static var previews: some View {
        ServersList(viewModel: ServersListViewModel(dataManager: ServersDataManager()))
    }
}
