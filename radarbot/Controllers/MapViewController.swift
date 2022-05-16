//
//  MapViewController.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 16/5/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let LATITUDE_DELTA_VALUE: Double = 0.01
    let LONGITUDE_DELTA_VALUE: Double = 0.01
    weak var delegate: MapViewControllerDelegate?
    private(set) var lastAnnotation: Annotation? = nil
    
    @IBOutlet weak var buttonAceptar: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func aceptar() {
        self.delegate?.MapViewControllerDelegateDidUpdate(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelar() {
        self.lastAnnotation = nil
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecognizer.minimumPressDuration = 0.1
        self.mapView.addGestureRecognizer(longPressRecognizer)
        
        checkLocationServices()
    }
    
    //MARK: - Location Manager
    
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocalizationAuthorization()
        } else {
            let deniedAlertController = UIAlertController(title: "Location is disabled", message: "For a better experience, please enable Location in Settings->Privacy->Location", preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            deniedAlertController.addAction(actionOk)
            present(deniedAlertController, animated: true, completion: nil)
        }
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocalizationAuthorization()
    {
        switch CLLocationManager.authorizationStatus()
        {
        case .authorizedWhenInUse:
            self.mapView.showsUserLocation = true
            centerViewOnUserLocation()
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            let deniedAlertController = UIAlertController(title: "Location denied", message: "You have no access to location services", preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            deniedAlertController.addAction(actionOk)
            present(deniedAlertController, animated: true, completion: nil)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
        default:
            print("Other location permission: \(CLLocationManager.authorizationStatus())")
            break
        }
    }
    
    func centerViewOnUserLocation()
    {
        if let location = self.locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: LATITUDE_DELTA_VALUE, longitudeDelta: LONGITUDE_DELTA_VALUE))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: LATITUDE_DELTA_VALUE, longitudeDelta: LONGITUDE_DELTA_VALUE))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocalizationAuthorization()
    }
    
    //MARK: - Annotations
    
    @objc func handleTap(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        gestureRecognizer.isEnabled = false
        
        if let last = self.lastAnnotation {
            mapView.deselectAnnotation(last, animated: true)
            mapView.removeAnnotation(last)
            mapView.reloadInputViews()
        }
        
        let location = gestureRecognizer.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let annotation = Annotation(latitude: coordinate.latitude, longitude: coordinate.longitude, ident: 1)
        self.mapView.addAnnotation(annotation)
        self.lastAnnotation = annotation
        
        gestureRecognizer.isEnabled = true
        
        buttonAceptar.isEnabled = true
        
        return
    }
}

protocol MapViewControllerDelegate: AnyObject {
    func MapViewControllerDelegateDidUpdate (_: MapViewController)
}
