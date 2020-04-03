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

class MapViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressLabel: UITextField!
    
    
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    var directionsArray: [MKDirections] = []
    
    var gpxContent = ""
    var markers = [(Double, Double, String, String, String, String)]()
    var waypoints = [Waypoint]()
    var linkedWaypoints = [(MKAnnotation, Waypoint)]()
    var annotationHash = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServies()
        mapView.delegate = self
        
        // parsing the GPX file, change the forResource to the name of the gpx file that is supposed to be parsed
        // if the GPX file is too large and has a lot of waypoints then the map will be slow to load, may want to use a smaller file for testing
        if let path = Bundle.main.url(forResource: "ExampleNYCGPX", withExtension: "gpx"){
            
            do{
                gpxContent = try String(contentsOf: path, encoding: String.Encoding.ascii)
            } catch let error as NSError{
                print("Failed to print from GPX File")
                print(error)
            }
        }
        
        let xml = XML(string: gpxContent)
        
        
        var index : Int = 0
        
        for waypoint in xml.wpt{
            var latitude = ""
            var latNum = Double()
            var longitude = ""
            var lonNum = Double()
            var nameOfLocation = ""
            var comment = ""
            var description = ""
            var link = ""
            var didFail = false
            
            if let lat = waypoint.$lat.string{
                latitude = lat
                if let latNumber = Double(latitude){
                    latNum = latNumber
                }
                else{
                    print("Could not convert Latitude to a Double")
                }
            }
            else{
                print("Could not retrieve latitude for waypoint \(index)")
                didFail = true
            }
            
            if let lon = waypoint.$lon.string{
                longitude = lon
                if let lonNumber = Double(longitude){
                    lonNum = lonNumber
                }
                else{
                    print("Could not convert Longitude to a Double")
                }
            }
            else{
                print("Could not retrieve longitude for waypoint \(index)")
                didFail = true
            }
            
            if let identifier = waypoint.name.string{
                nameOfLocation = identifier
            }
            else{
                print("Could not retrieve name for waypoint \(index)")
                didFail = true
            }
            
            if let com = waypoint.cmt.string{
                comment = com
            }
            else{
                print("Could not retrieve comment for waypoint \(index)")
                didFail = true
            }
            
            if let desc = waypoint.desc.string{
                description = desc
            }
            else{
                print("Could not retrieve description for waypoint \(index)")
                didFail = true
            }
            
            if let lin = waypoint.link.$href.string{
                link = lin
            }
            else{
                print("Could not retrieve link for waypoint \(index)")
                didFail = true
            }
            
            if didFail{
                print("Could not make a marker for waypoint \(index)")
            }
            else{
                markers.append((latNum, lonNum, nameOfLocation, comment, description, link))
                //print()
            }
            
            index = index + 1
            
        }
        
        
        for waypoint in markers{
            let lat = waypoint.0
            let lon = waypoint.1
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let wpt = Waypoint(coordinate: location, name: waypoint.2, comment: waypoint.3, desc: waypoint.4, link: waypoint.5)
            
            waypoints.append(wpt)
            
            let annotation = Pin(coordinate: location, title: waypoint.2, subtitle: waypoint.3)
            
            linkedWaypoints.append((annotation, wpt))
            mapView.addAnnotation(annotation)
        }
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
    
    // identifies the marker/waypoint that was clicked and segues to the WaypointViewController
    @objc func segueToWaypointView(sender: UIButton!){
        let button = sender as! UIButton
        annotationHash = button.tag
        performSegue(withIdentifier: "waypointSegue", sender: self)
        // add the code here
    }
    
    // finds and prepares to the send the correct waypoint information the WaypointViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var wpt : Waypoint?
        
        if let nextViewController = segue.destination as? WaypointViewController{
            // figures out which annotation goes with which button was pressed
            for i in linkedWaypoints{
                if annotationHash == i.0.hash{
                    wpt = i.1
                    annotationHash = 0
                }
            }
            
            // sends the waypoint to the WaypointViewController
            if let wayP = wpt{
                nextViewController.waypoint = wayP
            }
            else{
                print("Failed to find a valid waypoint")
            }
        }
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
    
    // adds the waypoints to the map as markers, adds the buttons that allow somebody to go to the WaypointViewController with the information about that waypoint
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if !(annotation is MKUserLocation){
            let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .contactAdd)
            rightButton.tag = annotation.hash
            rightButton.addTarget(self, action: #selector(segueToWaypointView), for: .touchUpInside)
            
            //pinView.animatesDrop = false
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            return pinView
        }
        else{
            return nil
        }
    }
}

