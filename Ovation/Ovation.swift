//
//  Ovation.swift
//  Ovation
//
//  Created by Dermot McCluskey on 31/05/2019.
//  Copyright © 2019 Dermot McCluskey. All rights reserved.
//

import Foundation

//Structure to hold one piece of information on a product
struct Ovation {
    let productID:Int
    let categoryID:Int
    let name:String
    let instructions:String
    let educationalComment:String
    let productImage:String
    let searchTags:String
    let dateModified:String
    
    enum SerialisationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    //initialiser, takes a JSON object which we expect to contain the appropriate name value pairs
    //If the object does not contain the names we expect we will throw an error
    init(json:[String:Any]) throws {
        guard let productID = json["ProductID"] as? String else {throw SerialisationError.missing("ProductID missing")}
        guard let categoryID = json["CategoryID"] as? String else {throw SerialisationError.missing("CategoryID missing")}
        guard let name = json["Name"] as? String else {throw SerialisationError.missing("name missing")}
        guard let instructions = json["Instructions"] as? String else {throw SerialisationError.missing("instructions missing")}
        guard let educationalComment = json["EducationalComment"] as? String else {throw SerialisationError.missing("educationalComment missing")}
        guard let productImage = json["ProductImage"] as? String else {throw SerialisationError.missing("productImage missing")}
        guard let searchTags = json["SearchTags"] as? String else {throw SerialisationError.missing("searchTags missing")}
        guard let dateModified = json["DateModified"] as? String else {throw SerialisationError.missing("dateModified missing")}
        
        self.productID = Int(productID) ?? 0
        self.categoryID = Int(categoryID) ?? 0
        self.name = name
        self.instructions = instructions
        self.educationalComment = educationalComment
        self.productImage = productImage
        self.searchTags = searchTags
        self.dateModified = dateModified
    }
    
    static let ovationURL = "http://admin.bin-ovation.com/api/product/"
    
    //Main function that will perform the URL request and parse the JSON into the structure
    //we have provided, When complete it will call the completion handler the user has provided
    static func GetOvation(completion: @escaping ([Ovation]) -> ()) {
        var ovationArray:[Ovation] = []
        let request = URLRequest(url: URL(string: ovationURL)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response:URLResponse?, error:Error?) in
            if let mdata = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: mdata, options: []) as? [String:Any] {
                        //print(json["Status"]!)
                        if let justData = json["Data"] as? [[String:Any]] {
                            for item in justData {
                                //print(" item: \(item)\n")
                                if let ovationObject = try? Ovation(json: item) {
                                    ovationArray.append(ovationObject)
                                    //print(" Name: \(ovationObject.name)")
                                    //print(" ID: \(ovationObject.productID)")
                                }
                                else {
                                    //print("Error")
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
            //print("Number \(ovationArray.count)")
            completion(ovationArray)
        }
        task.resume()
    } //end of GetOvation function
} //end of struct Ovation
