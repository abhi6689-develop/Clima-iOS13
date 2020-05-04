//
//  ViewController.swift
//  Clima
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var LocationButton: UIButton!
    var weatherManager = WeatherManager()
    let LocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.requestLocation()
//      Use LocationManager.startUpdatingLocation() when continous data is needed
        searchField.delegate = self
        weatherManager.delegate = self
        // The text field is reporting back to the view controller
    }
    
    @IBAction func LocationButtonPressed(_ sender: UIButton) {
        LocationManager.requestLocation()
        
    }
}

//MARK: - UITextFieldDelegate Section

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchSelected(_ sender: UIButton) {
           searchField.endEditing(true)
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool // The user pressed the return key
       {
           searchField.endEditing(true)
           return true
       }
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != ""
           {
               return true
           }
           else
           {
               textField.placeholder = "Type a name"
               return false
           }
           // In this case, we are using textField instead of searchField because any text field linked to the button could be the empty text field that leads to the throwing of this exception
           
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           // Use searchField to get the weather for the typed place
           if let city = searchField.text{
               weatherManager.fetchWeather(cityName: city)
           }
           searchField.text = ""
       }
}

//MARK: - UpdateweatherDelegate Section

extension WeatherViewController: UpdateWeather{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text =  weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.city
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
//MARK: - LocationManagerDelegate section


extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.last{
        LocationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        weatherManager.fetchWeatherbyCoordinates(Latitude: lat, Longitude: long)
        
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

