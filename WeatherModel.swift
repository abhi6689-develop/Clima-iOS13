//
//  WeatherModel.swift
//  Clima
//
//  Created by Abhishek Tiwari on 02/05/20.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let city: String
    let Temp: Double
    var conditionName: String {
        switch conditionId{
        case 200...232:
            return("cloud.bolt.rain")
        case 300...322:
            return("cloud.drizzle")
        case 500...531:
            return("cloud.rain")
        case 600...622:
            return("snow")
        case 700...781:
            return("cloud.sun")
        case 800:
            return("sun.max")
        default:
            return("cloud")
        }
        
    }
    
    var tempString: String{
        return String(format: "%.1f", Temp)
    }
}


