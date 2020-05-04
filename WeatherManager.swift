//
//  WeatherManager.swift
//  Clima
//
//  Created by Abhishek Tiwari on 02/05/20.
//

import Foundation
import CoreLocation

protocol UpdateWeather {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager
{
    var delegate: UpdateWeather?
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=5d72dbca8551409724c41d466f9c408b"
    
    func fetchWeather(cityName:String){
        let Url = "\(weatherUrl)&q=\(cityName)" // creating an url object
        performRequest(with: Url) //passing the Url
    }
    func performRequest(with Url:String){ //networking is happening here
        if let urls = URL(string: Url){ // creating the url in the performrequest method
            // Create an url session
            let session = URLSession(configuration: .default)
            // Give the session a task
            let task = session.dataTask(with: urls) { (data, response, error) in  // gets exceuted only if the error is nil
                       if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data{
                        if let weather = self.parseJSON(safeData){
                            self.delegate?.didUpdateWeather(self, weather: weather)
                            
                            
                        }
                    }
                }
            // start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            let weather = WeatherModel(conditionId: id, city: city, Temp: temp)
            return weather
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil 
        }
    }
    func fetchWeatherbyCoordinates(Latitude: CLLocationDegrees, Longitude: CLLocationDegrees){
        let Url = "\(weatherUrl)&lat=\(Latitude)&lon=\(Longitude)" // creating an url object
        performRequest(with: Url)
    }
}

