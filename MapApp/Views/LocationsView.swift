//
//  LocationsView.swift
//  MapApp
//
//  Created by dofxmine on 16.03.2025.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        ZStack {
            mapLayer
                .ignoresSafeArea()
            VStack(spacing: 0) {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                Spacer()
                locationsPreviewStack
            }
        }
        .sheet(
            item: $vm.sheetLocation,
            onDismiss: nil) { location in
                LocationDetailView(location: location)
            }
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}

extension LocationsView {
    
    private var header: some View {
        VStack {
            
            Button {
                vm.toggleLocationsList()
            } label: {
                Text("\(vm.mapLocation.name), \(vm.mapLocation.cityName)")
                    .font(.title2)
                    .fontWeight(.black)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
            }
            .foregroundStyle(.primary)
            
            if vm.showLocationsList {
                LocationsListView()
            }
            
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Map(
            coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                    // MARK: FIX SCALE EFFECT
                        .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            vm.showNextLocation(location: location)
                        }
                    
                }
            })
        
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: .black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
                
            }
        }
    }
}
