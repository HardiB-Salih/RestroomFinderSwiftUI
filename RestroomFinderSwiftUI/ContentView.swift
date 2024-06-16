//
//  ContentView.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.httpClient) private var httpClient
    @State private var locationManager = LocationManager.shared
    @State private var restrooms: [Restroom] = []
    @State private var selectedRestroom: Restroom?
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var position : MapCameraPosition = .userLocation(fallback: .automatic)
    
    private func loadRestrooms() async {
//        let coordinate = locationManager.region.center
        guard let visibleRegion else { return }
        let coordinate = visibleRegion.center

        let restroomsUrl = Constants.URLs.restroomsByLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print(restroomsUrl)
        do {
            restrooms = try await httpClient.fetchRestrooms(url: restroomsUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Map (position: $position){
                ForEach(restrooms) { restroom in
                    Annotation(restroom.name, coordinate: restroom.coordinate) {
                        Image("restroom")
                            .resizable()
                            .scaleEffect(selectedRestroom == restroom ? 1.4 : 1.0)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                selectedRestroom = restroom
                            }
                            .animation(.spring, value: selectedRestroom)
                    }
                }
                UserAnnotation()
            }
            
            if  let selectedRestroom {
                RestroomDetailView(restroom: selectedRestroom) {
                    withAnimation {
                        self.selectedRestroom = nil
                    }
                }
            }
        }
        .ignoresSafeArea()
        .animation(.snappy, value: selectedRestroom)
        
//        .sheet(item: $selectedRestroom, content: { restroom in
//            RestroomDetailView(restroom: restroom)
//                .presentationDetents([.fraction(0.25), .medium])
//        })
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .overlay(alignment: .topLeading, content: {
            Button(action: {
                Task { await loadRestrooms() }
            }, label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white, Color(.link))
                    .padding()
            })
        })
        .task(id: locationManager.region) {
            visibleRegion = locationManager.region
            await loadRestrooms()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.httpClient, MockRestroomClient())
}
