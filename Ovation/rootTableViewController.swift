//
//  rootTableViewController.swift
//  Ovation
//
//  Created by Dermot McCluskey on 31/05/2019.
//  Copyright © 2019 Dermot McCluskey. All rights reserved.
//

import UIKit

struct CategorySection : Comparable {
    static func == (lhs: CategorySection, rhs: CategorySection) -> Bool {
        return lhs.categoryID == rhs.categoryID
    }
    static func < (lhs: CategorySection, rhs: CategorySection) -> Bool {
        return lhs.categoryID < rhs.categoryID
    }
    var categoryID : Int
    var ovation : [Ovation]
}

class rootTableViewController: UITableViewController {
    
    private var fetchedResults :[Ovation] = []
    var groupedDict = [Int(): [Ovation]()] as [Int: [Ovation]]
    
    private var userRow:Ovation!
    private var grouped:Bool = false
    
    @IBOutlet weak var activityInfo: UIActivityIndicatorView!
    @IBOutlet var ovationTableList: UITableView!
    @IBAction func groupedClicked(_ sender: Any) {
        grouped = true
        groupedDict = Dictionary(grouping: fetchedResults, by: { $0.categoryID })
        ovationTableList.reloadData()
        ovationTableList.setContentOffset(.zero, animated: true)
        let p = CGPoint(x: 0, y: -30)
        ovationTableList.setContentOffset(p, animated: true)
        //ovationTableList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        //scrollToFirstRow()
    }
    @IBAction func aToZClicked(_ sender: Any) {
        grouped = false
        fetchedResults = fetchedResults.sorted { $0.name < $1.name }
        ovationTableList.reloadData()
        scrollToFirstRow()
    }
    @IBAction func idClicked(_ sender: Any) {
        grouped = false
        fetchedResults = fetchedResults.sorted { $0.productID < $1.productID }
        ovationTableList.reloadData()
        scrollToFirstRow()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                
        activityInfo.startAnimating()
        activityInfo.isHidden = false
        
        //ovationTableList
        
        Ovation.GetOvation() {
            (results:[Ovation]) in
            self.fetchedResults = results
            DispatchQueue.main.async {
                // UIView usage
                self.activityInfo.stopAnimating()
                self.activityInfo.isHidden = true
                self.ovationTableList.isHidden = false
                self.ovationTableList.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows =  fetchedResults.count
        if grouped {
            numberOfRows = groupedDict[section]?.count ?? 0
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Simple Sort"
        label.backgroundColor = UIColor.lightGray
        if (grouped) {
            label.text = "Catagory ID: \(section)"
            if section == 0 {
                label.text = "Group by Category"
            }
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        var name = fetchedResults[indexPath.row].name
        if grouped {
            name = groupedDict[indexPath.section]?[indexPath.row].name ?? "Unknown"
        }
        //cell.textLabel?.text = "\(name)     section: \(indexPath.section)    row: \(indexPath.row)"
        cell.textLabel?.text = "\(name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        userRow = fetchedResults[indexPath.row]
        if grouped {
            userRow = groupedDict[indexPath.section]?[indexPath.row]
        }
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections : Int = 1
        if grouped {
            numberOfSections = groupedDict.count
        }
        return numberOfSections
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? newViewController {
            destination.fetchedResults = userRow
        }
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.ovationTableList.scrollToRow(at: indexPath, at: .top, animated: true)
    }

}
