//
//  AlertType.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 14/5/22.
//

import UIKit

enum AlertType: String, CaseIterable
{
    case radarFijo = "Radar Fijo"
    case atasco = "Atasco"
    case policia = "Policía"
    case peligroEnLaVia = "Peligro en la vía"
    case radarMovil = "Radar Móvil"
    case accidente = "Accidente"
    case comentario = "Comentario"
    
    func id() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)! + 1
    }
    
    func getIconName() -> String {
        switch self {
            case .radarFijo: return "radarFijo"
            case .policia: return "policia"
            case .atasco: return "atasco"
            case .peligroEnLaVia: return "peligroEnLaVia"
            case .accidente: return "accidente"
            case .radarMovil: return "radarMovil"
            case .comentario: return "comentario"
        }
    }
    
    func getColor() -> UIColor {
        switch self {
            case .radarFijo: return .blue
            case .policia: return .systemBlue
            case .atasco: return .systemRed
            case .peligroEnLaVia: return .systemYellow
            case .accidente: return .systemPurple
            case .radarMovil: return .systemBlue
            case .comentario: return .systemOrange
        }
    }
}
