//
//  MapManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/26/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import GoogleMaps

class MapManager
{
    static let BOSTON_MAP = MapManager.mapViewWithLatitude(kCoordinateBostonLatitude, longitude: kCoordinateBostonLongitude, zoom: kMapStandardZoom)
    static let BOSTON_MARKER = MapManager.markerWithLatitude(kCoordinateBostonLatitude, longitude: kCoordinateBostonLongitude, title: kStringBoston, snippet: kStringMassachusetts)
    static let BOSTON_MARKER_CUSTOM = MapManager.customMarkerWithLatitude(kCoordinateBostonLatitude, longitude: kCoordinateBostonLongitude, title: kStringBoston, snippet: kStringMassachusetts)
    
    static func mapViewWithLatitude(latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) -> GMSMapView
    {
        let camera = GMSCameraPosition.cameraWithLatitude(latitude,
            longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        return mapView
    }
    
    static func markerWithLatitude(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, snippet: String) -> GMSMarker
    {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = title
        marker.snippet = snippet
        return marker
    }
    
    static func customMarkerWithLatitude(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, snippet: String) -> GMSMarker
    {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = title
        marker.snippet = snippet
        marker.icon = UIImage(named: "lockMarker")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate).imageWithColor(Colors.markerColor)
        return marker
    }
}