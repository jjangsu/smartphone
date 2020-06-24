//
//  MasterViewController.swift
//  SplitView
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var siteNames: [String]?
    var siteAddresses: [String]?

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        siteNames = ["Yahoo", "Google", "Apple", "Bing"]
        siteAddresses = ["https://www.yahoo.com", 
                         "https://www.google.com", 
                         "https://www.apple.com", 
                         "https://www.bing.com"]

        if let split = splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! 
                UINavigationController).topViewController
                    as? DetailViewController
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let urlString = siteAddresses?[indexPath.row]

            let controller = (segue.destination
                   as! UINavigationController).topViewController
            as! DetailViewController

            controller.detailItem = urlString as AnyObject?
            controller.navigationItem.leftBarButtonItem =
                            splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton
                                        = true
        }

    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteNames!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)

        cell.textLabel!.text = siteNames![indexPath.row]
        return cell

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

