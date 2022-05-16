//
//  AlertService.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 16/5/22.
//

import Foundation

class AlertService
{
    private(set) var response = Response()
    weak var delegate: AlertServiceDelegate?
    
    func notifyAlert(latitude: Double, longitude: Double, alertType: Int, text: String)
    {
        let service = APIManager(url: getDummyUrl(latitude: latitude, longitude: longitude, alertType: alertType, text: text))
        service.get() { (response: Response?) in
            if let response = response {
                self.response = response
                self.delegate?.alertServiceDelegateDidUpdate(self)
            }
        }
    }
    
    private func getDummyUrl(latitude: Double = DummyServiceSettings.defaultLatitude, longitude: Double = DummyServiceSettings.defaultLongitude, alertType: Int, text: String) -> String
    {
        return "\(DummyServiceSettings.serviceUrl)?lat=\(latitude)&lon=\(longitude)&alert_type=\(alertType))&text=\(text)"
    }
}

protocol AlertServiceDelegate: AnyObject
{
    func alertServiceDelegateDidUpdate(_: AlertService)
}
