//
//  ViewController.swift
//  Hystouri
//
//  Created by Isaac Bredbenner (student LM) on 2/18/20.
//  Copyright © 2020 Isaac Bredbenner (student LM). All rights reserved.
//
import MapKit
import UIKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressLabel: UITextField!
    
   
    
        let locationManager = CLLocationManager()
        let regionInMeters: Double = 10000
        var previousLocation: CLLocation?
        var directionsArray: [MKDirections] = []
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            checkLocationServies()
        }
        func setUpLocationManager(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        func centerViewOnUserLocation(){
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                mapView.setRegion(region, animated: true)
            }
        }

        func checkLocationServies(){
            if CLLocationManager.locationServicesEnabled(){
                setUpLocationManager()
                checkLocationAuthorization()
            }else{
                //show alert letting user know they have to turn this on.
            }
        }

        func checkLocationAuthorization(){
            switch CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
                startTrackingUserLocation()
            case .denied:
                //show alert instructing them how to turn on permissions
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                //show alert letting them know what's up
                break
            case .authorizedAlways:
                break
            }
        }
        
        func startTrackingUserLocation(){
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            previousLocation = getCenterLocation(for: mapView)
        }
        
        func getCenterLocation(for mapview: MKMapView) -> CLLocation{
            let latitude = mapView.centerCoordinate.latitude
            let longitude = mapView.centerCoordinate.longitude
            
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        
        func getDirections(){
            guard let location = locationManager.location?.coordinate else{
                //ToDo
                return
            }
            
            let request = createDirectionsRequest(from: location)
            let directions = MKDirections(request: request)
            resetMapView(withNew: directions)
            
            directions.calculate { [unowned self] (response, error) in
                
                guard let response = response else { return }
            
                for route in response.routes {
                    //_ = route.steps (written directions)
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            }
        }
        
        func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request{
            let destinationCoordinate = getCenterLocation(for: mapView).coordinate
            let startingLocation = MKPlacemark(coordinate: coordinate)
            let destination = MKPlacemark(coordinate: destinationCoordinate)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startingLocation)
            request.destination = MKMapItem(placemark: destination)
            request.transportType = .automobile
            request.requestsAlternateRoutes = true
            
            return request
        }
        
        func resetMapView(withNew directions: MKDirections) {
            mapView.removeOverlays(mapView.overlays)
            directionsArray.append(directions)
            let _ = directionsArray.map { $0.cancel() }
        }
        
        @IBAction func goButtonTapped(_sender: UIButton){
            getDirections()
            _sender.setImage(#imageLiteral(resourceName: "end"), for: .normal)
        }
    }

    extension MapViewController: CLLocationManagerDelegate{
        
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
    }

    extension MapViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = getCenterLocation(for: mapView)
            let geoCoder = CLGeocoder()
            
            guard let previousLocation = self.previousLocation else {return}
            
            guard center.distance(from: previousLocation) > 50 else {return}
            self.previousLocation = center
            
            geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
                guard let self = self else {return}
                
                if let _ = error {
                    //show alert informing the user
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    //show alert informing the user
                    return
                }
                
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                
                DispatchQueue.main.async {
                    self.addressLabel.text = "\(streetNumber) \(streetName)"
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 7
           
            
            return renderer
        }
    }

