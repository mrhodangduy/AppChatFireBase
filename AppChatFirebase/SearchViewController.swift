//
//  SearchViewController.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/13/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


let client_id = "IV3NO1KJ1DCX11SJU5LTPMPLOLP5TMUEMTLVMRAE4PYPL4FE" // visit developer.foursqure.com for API key
let client_secret = "HZKW23ZIANNPK3U0KJC1LHUUVWGCL5LZQPIK500TQM032BNA" // visit developer.foursqure.com for API key


class SearchViewController: UIViewController {

    @IBOutlet weak var resulttableView: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var flag = true
    
    var searchResults = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("sadasdsads")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                return
            }
        } else {
            return
        }
        
        resulttableView.delegate = self
        resulttableView.dataSource = self
        
//        snapToPlace()
        searchForCoffee()
        print(searchResults)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        flag = true
    }
    
    @IBAction func closeAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func snapToPlace() {
        let url = "https://api.foursquare.com/v2/venues/search?ll=\(currentLocation.latitude),\(currentLocation.longitude)&v=20170913&intent=checkin&limit=1&radius=100&client_id=\(client_id)&client_secret=\(client_secret)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            var currentVenueName:String?
            
            let json = JSON(data: data!)
            currentVenueName = json["response"]["venues"][0]["name"].string
                        
            DispatchQueue.main.async {
                if let v = currentVenueName
                {
                    print(v)
                }
            }
            
            // set label name and visible
//            DispatchQueue.main.async {
//                if let v = currentVenueName {
//                    self.currentLocationLabel.text = "You're at \(v). Here's some ☕️ nearby."
//                }
//                self.currentLocationLabel.isHidden = false
//            }
        })
        
        task.resume()
    }
    
    // MARK: - search/recommendations endpoint
    // https://developer.foursquare.com/docs/search/recommendations
    func searchForCoffee() {
        let url = "https://api.foursquare.com/v2/search/recommendations?ll=\(currentLocation.latitude),\(currentLocation.longitude)&v=20160607&intent=food&limit=20&client_id=\(client_id)&client_secret=\(client_secret)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let json = JSON(data: data!)
            print(json)
            self.searchResults = json["response"]["group"]["results"].arrayValue
            
            DispatchQueue.main.async {
                self.resulttableView.reloadData()
            }
        })
        
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["name"].string
        cell.detailTextLabel?.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["location"]["address"].string
        
        return cell
    }
}

extension SearchViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last?.timestamp.timeIntervalSinceNow < -30.0 || locations.last?.horizontalAccuracy > 80 {
            return
        }
        
        // set a flag so segue is only called once
        if flag {
            currentLocation = locations.last?.coordinate
            locationManager.stopUpdatingLocation()
            flag = false
        }
    }
    
}

