//
//  newViewController.swift
//  Ovation
//
//  Created by Dermot McCluskey on 07/06/2019.
//  Copyright © 2019 Dermot McCluskey. All rights reserved.
//

import UIKit

class newViewController: UIViewController {
    
    var fetchedResults :Ovation!

    @IBOutlet weak var prodName: UILabel!
    
    
    @IBOutlet weak var productIds: UILabel!
    @IBOutlet weak var instructions: UILabel!
    
    @IBOutlet weak var educationTv: UITextView!
    @IBOutlet weak var searchTags: UITextView!
    @IBOutlet weak var dateModified: UILabel!
    @IBOutlet weak var ImageName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        populateView()
    }
    
    
    func populateView() {
        prodName.text = fetchedResults.name
        let ids = "Prod ID: \(fetchedResults.productID) Cat ID: \(fetchedResults.categoryID)"
        productIds.text = ids
        instructions.text = fetchedResults.instructions
        
        let educ = UsefullFunctions.Split(line: fetchedResults.educationalComment, with: "</p>")
        
        //use the html2Attributed string extension
        educationTv.attributedText = educ.html2Attributed
        educationTv.scrollRangeToVisible(NSRange(location:0, length:0))
        
        let alltags = UsefullFunctions.SplitAndReturnAll(line: fetchedResults.searchTags, with: ",")
        searchTags.text=""
        for tag in alltags {
            searchTags.text.append(tag)
        }
        searchTags.scrollRangeToVisible(NSRange(location:0, length:0))
        
        dateModified.text = "Date Modified: \(fetchedResults.dateModified)"
        
        ImageName.text = UsefullFunctions.SplitFilename(path: fetchedResults.productImage)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
