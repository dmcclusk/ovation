//
//  detailViewController.swift
//  Ovation
//
//  Created by Dermot McCluskey on 31/05/2019.
//  Copyright © 2019 Dermot McCluskey. All rights reserved.
//

import UIKit


class detailViewController: UIViewController {

    var fetchedResults :Ovation!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prodAndCatLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var educationalCommentTextView: UITextView!
    @IBOutlet weak var productImageLabel: UILabel!
    
    @IBOutlet weak var searchFieldsTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateView()
    }
    

    
    //simple function to extract the html paragraph from the educationalComment string
    func splitEducation(line: String) -> String{
        
        var data = line.components(separatedBy: "</p>")
        if (data.count > 0) {
            return data[0]
        }
        return line
    }
    
    //takes a comma separated string and returns an array of strings
    func searchTagIndividuals(line: String) -> [String] {
        var strArray = [String]()
        let data = line.components(separatedBy: ",")
        if data.count > 0 {
            for indi in data {
                strArray.append("\(indi.trim())\n")
            }
        }
        else {
            strArray.append(line)
        }
        return strArray
    }
    
    //this function populates the view with the data in the passed in Ovation struct
    func populateView() {
        nameLabel.text = "\(fetchedResults.name)"
        prodAndCatLabel.text="product: \(fetchedResults.productID)  Category: \(fetchedResults.categoryID)"
        instructionsLabel.text="\(fetchedResults.instructions)"
        
        let splitline = splitEducation(line: fetchedResults.educationalComment)
        
        //use the html2Attributed string extension
        educationalCommentTextView.attributedText = splitline.html2Attributed
        educationalCommentTextView.scrollRangeToVisible(NSRange(location:0, length:0))
        
        productImageLabel.text = fetchedResults.productImage
        
        let alltags = searchTagIndividuals(line: fetchedResults.searchTags)
        searchFieldsTextView.text=""
        for tag in alltags {
            searchFieldsTextView.text.append(tag)
        }
        searchFieldsTextView.scrollRangeToVisible(NSRange(location:0, length:0))
        dateLabel.text = fetchedResults.dateModified
    }

}
