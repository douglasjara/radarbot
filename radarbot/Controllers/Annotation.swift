//
//  Annotation.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 16/5/22.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation
{
    private(set) var title : String?
    var latitude : Double
    var longitude : Double
    var identifier : Int
    var address : String
    var coordinate : CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, ident: Int)
    {
        self.title = "Has marcado aquí"
        self.latitude = latitude
        self.longitude = longitude
        self.identifier = ident
        self.address = ""
    }
}
