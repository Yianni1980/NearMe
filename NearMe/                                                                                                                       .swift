//
//  ViewController.swift
//  NearMe
//
//  Created by ioannis on 10/1/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var locationManager:CLLocationManager?
    
    private var places: [PlaceAnnotation] = []
    
    lazy var mapView:MKMapView = {
       let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    lazy var searchTextfield : UITextField = {
        let searchTextfield = UITextField()
        searchTextfield.layer.cornerRadius = 10
        searchTextfield.delegate = self
        searchTextfield.clipsToBounds = true
        searchTextfield.backgroundColor = UIColor.white
        searchTextfield.placeholder = "Search"
        searchTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextfield.translatesAutoresizingMaskIntoConstraints = false
        return searchTextfield
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize location Manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        setupUI()
    }
    
    private func setupUI () {
        view.addSubview(searchTextfield)

        view.addSubview(mapView)
        
        view.bringSubviewToFront(searchTextfield)

        
        //add contraints to the searchTextField
        searchTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextfield.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchTextfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchTextfield.returnKeyType  = .go
        
        
        //add constraints to the mapView
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager,
              let location  = locationManager.location else {
            return
        }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined,.restricted:
            print("Location cannot be determined or restricted")
        case .denied:
            print("Location services has been denied")
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        @unknown default:
            break
        }
    }
    
    private func presentPlacesSheet(places:[PlaceAnnotation]) {
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location else {
            return
        }
        
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(),.large()]
            present(placesTVC,animated:true)
        }
    }
    
    private func findNearbyPlaces(by query: String) {
         
         //clear all annotations if we have
        mapView.removeAnnotations(mapView.annotations)
         
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start {[weak self] response, error  in
            guard let response  = response , error == nil  else {return}
            
            self?.places  =  response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach({ place in
                self?.mapView.addAnnotation(place)
                
            })
            
            if let places = self?.places {
                self?.presentPlacesSheet(places:places)

            }
        }
    
        
    }
}

extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelections() {
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
        
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        //clear all sections
        
        clearAllSelections()
        
        guard let selectedAnnotation =  annotation as? PlaceAnnotation else {
            return
        }
        
        let placeAnnotation  = self.places.first(where: {$0.id == selectedAnnotation.id})
        
        placeAnnotation?.isSelected = true
        
        presentPlacesSheet(places: self.places)
    }
    
    
}


extension ViewController :UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            //find nearby places
            findNearbyPlaces(by: text)
        }
        
        return true
    }
    
}

  

extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
