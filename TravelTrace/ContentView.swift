//
//  ContentView.swift
//  TravelTrace
//
//  Created by Berend Vandenbussche on 25/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PhotoLocationViewModel()

        var body: some View {
            NavigationView {
                VStack {
                    Text("Countries from Photo Locations")
                        .font(.title)
                        .padding()

                    List {
                        ForEach(Array(viewModel.countries), id: \.self) { country in
                            Text(country)
                        }
                    }
                    .listStyle(PlainListStyle())

                    Button(action: {
                        viewModel.requestPhotoLibraryAccess()
                    }) {
                        Text("Request Photo Library Access")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .navigationTitle("Photo Locations")
                .onAppear {
                    viewModel.requestPhotoLibraryAccess()
                }
            }
        }
    }

    struct PhotoLocationView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

#Preview {
    ContentView()
}
