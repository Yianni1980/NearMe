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
    
    lazy var mapView:MKMapView = {
       let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
    
        return map
    }()
    lazy var searchTextfield : UITextField = {
        let searchTextfield = UITextField()
        searchTextfield.layer.cornerRadius = 10
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


}

