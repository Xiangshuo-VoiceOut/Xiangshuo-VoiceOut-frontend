//
//  MapView.swift
//  TherapistLocationPopup
//
//  Created by Yujia Yang on 7/20/24.
//
import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .onChange(of: locationManager.location) { newLocation in
                    if let newLocation = newLocation {
                        region = MKCoordinateRegion(center: newLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    }
                }
            //精确定位
            HStack(alignment: .center, spacing: ViewSpacing.xsmall)  {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 9.2)
                Text(LocalizedStringKey("TurnOnPreciseLocation"))
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.blue)
                    .frame(height: 17, alignment: .leading)
                
            }
            .padding(.horizontal, ViewSpacing.betweenSmallAndBase)
            .padding(.vertical,ViewSpacing.xsmall )
            .frame(height:25)
            .background(.white)
            .cornerRadius(1000)
            .padding(.top, 5)
            .padding(.leading, 10)
            .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 3)
        }
        .frame(width: 270, height: 174)
        .cornerRadius(CornerRadius.xxxsmall.value)

    }
}
