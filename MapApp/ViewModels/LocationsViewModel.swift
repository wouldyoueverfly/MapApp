//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by dofxmine on 16.03.2025.
//

import Foundation

class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location]
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
    }
}
