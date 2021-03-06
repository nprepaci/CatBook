//
//  API.swift
//  AboutMeApi
//
//  Created by Nicholas Repaci on 9/1/21.
//

import Foundation
import UIKit

//Structs for JSON decoding
struct Response: Codable {
  let weight: Weight
  let id, name: String
  let cfaURL: String?
  let vetstreetURL: String?
  let vcahospitalsURL: String?
  let temperament, origin, countryCodes, countryCode: String
  let description, lifeSpan: String
  let indoor: Int
  let lap: Int?
  let altNames: String?
  let adaptability, affectionLevel, childFriendly, dogFriendly: Int
  let energyLevel, grooming, healthIssues, intelligence: Int
  let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
  let experimental, hairless, natural, rare: Int
  let rex, suppressedTail, shortLegs: Int
  let wikipediaURL: String?
  let hypoallergenic: Int
  let referenceImageID: String?
  let image: Image?
  let catFriendly, bidability: Int?
  
  enum CodingKeys: String, CodingKey {
    case weight, id, name
    case cfaURL = "cfa_url"
    case vetstreetURL = "vetstreet_url"
    case vcahospitalsURL = "vcahospitals_url"
    case temperament, origin
    case countryCodes = "country_codes"
    case countryCode = "country_code"
    case description = "description"
    case lifeSpan = "life_span"
    case indoor, lap
    case altNames = "alt_names"
    case adaptability
    case affectionLevel = "affection_level"
    case childFriendly = "child_friendly"
    case dogFriendly = "dog_friendly"
    case energyLevel = "energy_level"
    case grooming
    case healthIssues = "health_issues"
    case intelligence
    case sheddingLevel = "shedding_level"
    case socialNeeds = "social_needs"
    case strangerFriendly = "stranger_friendly"
    case vocalisation, experimental, hairless, natural, rare, rex
    case suppressedTail = "suppressed_tail"
    case shortLegs = "short_legs"
    case wikipediaURL = "wikipedia_url"
    case hypoallergenic
    case referenceImageID = "reference_image_id"
    case image
    case catFriendly = "cat_friendly"
    case bidability
  }
}

struct Image: Codable {
  let id: String?
  let width, height: Int?
  let url: String?
}

struct Weight: Codable {
  let imperial, metric: String
}

typealias ResponseData = [Response]


// Class with API GET func
class API {
  
  // Stores data from GET request
  var storedData = ResponseData()
  
  // Fetches data from thecatapi, and stores it in a varible. Utilizes a completion handler so we can easily refresh the table view once complete.
  func loadData(activityIndicator: UIActivityIndicatorView, completionHandler: @escaping (ResponseData) -> Void) {
    
    // Starts activity indicator
    activityIndicator.startAnimating()
    
    guard let url = URL(string:"https://api.thecatapi.com/v1/breeds?limit=20") else {
      print("failed to fetch data")
      activityIndicator.stopAnimating()
      return
    }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        do {
          let response = try JSONDecoder().decode(ResponseData.self, from: data)
          DispatchQueue.main.async {
            self.storedData = response
            completionHandler(self.storedData)
            activityIndicator.stopAnimating()
          }
        }
        catch let error {
          print(error)
        }
        return
      }
      print("failed \(error?.localizedDescription ?? "unknown error")")
    }
    .resume()
  }
}



