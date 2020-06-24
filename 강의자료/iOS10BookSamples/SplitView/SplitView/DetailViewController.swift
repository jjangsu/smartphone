//
//  DetailViewController.swift
//  SplitView
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
        if let myWebview = webView {
            let url = NSURL(string: detail as! String)
            let request = NSURLRequest(url: url! as URL)
            myWebview.scalesPageToFit = true
            myWebview.loadRequest(request as URLRequest)
        }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

