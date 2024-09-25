//
//  PhotoLocationViewModel.swift
//  TravelTrace
//
//  Created by Berend Vandenbussche on 25/09/2024.
//
import SwiftUI
import Photos
import CoreLocation

class PhotoLocationViewModel: ObservableObject {
    @Published var countries: Set<String> = []
    private let geocoder = CLGeocoder()

    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.fetchPhotos()
            case .denied, .restricted:
                print("Access denied or restricted.")
            case .notDetermined:
                print("Authorization not determined.")
            case .limited:
                print("Limited access to the photo library.")
            @unknown default:
                break
            }
        }
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        assets.enumerateObjects { asset, _, _ in
            self.extractLocation(from: asset)
        }
    }

    private func extractLocation(from asset: PHAsset) {
        guard let location = asset.location else { return } // Check if photo has location data
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        getCountry(from: latitude, longitude: longitude)
    }

    private func getCountry(from latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first, let country = placemark.country else {
                print("Failed to get country from coordinates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.countries.insert(country)
                print("Country found: \(country)")
            }
        }
    }
}
