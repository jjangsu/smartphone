//
//  ViewController.swift
//  TwitterApp
//
//  Created by Neil Smyth on 10/11/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Social
import Accounts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    var dataSource = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    tweetTableView.register(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    getTimeLine()
    tweetTableView.estimatedRowHeight = 50

    }

func getTimeLine() {

    let account = ACAccountStore()
    let accountType = account.accountType(
        withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)

    account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success, error) in

        if success {
            let arrayOfAccounts =
                account.accounts(with: accountType)

            if (arrayOfAccounts?.count)! > 0 {
                let twitterAccount = arrayOfAccounts?.last as! ACAccount

                let requestURL = URL(string:
        "https://api.twitter.com/1.1/statuses/user_timeline.json")

                let parameters = ["screen_name" : "@techotopia",
                    "include_rts" : "0",
                    "trim_user" : "1",
                    "count" : "20"]

                let postRequest = SLRequest(forServiceType:
                        SLServiceTypeTwitter,
                        requestMethod: SLRequestMethod.GET,
                        url: requestURL,
                        parameters: parameters)

                postRequest?.account = twitterAccount

                postRequest?.perform(handler: {(responseData, urlResponse, error) in

                do {
                    try self.dataSource = JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [AnyObject]

                    if self.dataSource.count != 0 {
                        DispatchQueue.main.async() {
                            self.tweetTableView.reloadData()
                        }
                    }
                } catch let error as NSError {
                    print("Data serialization error: \(error.localizedDescription)")
                }
              })
            }
        } else {
            print("Failed to access account")
         }
    })
}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
       tableView.dequeueReusableCell(withIdentifier: "Cell")
    let row = indexPath.row
    let tweet = self.dataSource[row]
    cell!.textLabel!.text = tweet.object(forKey: "text") as? String
    cell!.textLabel!.numberOfLines = 0
    return cell!

}

}

