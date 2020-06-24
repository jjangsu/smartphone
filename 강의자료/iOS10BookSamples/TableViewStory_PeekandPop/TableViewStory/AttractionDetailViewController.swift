//
//  AttractionDetailViewController.swift
//  TableViewStory
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class AttractionDetailViewController: UIViewController {

    var webSite: String?
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

       if let address = webSite {
            let webURL = URL(string: address)
            let urlRequest = URLRequest(url: webURL!)
            webView.loadRequest(urlRequest)
        }

    }

    override var previewActionItems: [UIPreviewActionItem] {

        let action1 = UIPreviewAction(title: "Action One",
                            style: .destructive,
                            handler: { previewAction, viewController in
                                    print("Action One Selected")
                            })

        let action2 = UIPreviewAction(title: "Action Two",
                            style: .selected,
                            handler: { previewAction, viewController in
                                    print("Action Two Selected")
                            })

        let groupAction1 = UIPreviewAction(title: "Group Action One",
                              style: .default,
                              handler: { previewAction, viewController in
                                    print("Group Action One Selected")
                              })

        let groupAction2 = UIPreviewAction(title: "Group Action Two",
                              style: .default,
                              handler: { previewAction, viewController in
                                    print("Group Action Two Selected")
                              })

        let groupActions = UIPreviewActionGroup(title: "My Action Group...",
                                    style: .default,
                                    actions: [groupAction1, groupAction2])

        return [action1, action2, groupActions]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
