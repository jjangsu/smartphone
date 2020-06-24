//
//  PurchaseViewController.swift
//  InAppDemo
//
//  Created by Neil Smyth on 10/11/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var buyButton: UIButton!

    var product: SKProduct?
    var productID = "<YOUR PRODUCT ID GOES HERE>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyButton.isEnabled = false
        SKPaymentQueue.default().add(self)
        getProductInfo()

    }

    @IBAction func buyProduct(_ sender: AnyObject) {
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)

    }
    
    func getProductInfo()
    {
        if SKPaymentQueue.canMakePayments() {

            let request = SKProductsRequest(productIdentifiers: 
            NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            productDescription.text =
                        "Please enable In App Purchase in Settings"
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        var products = response.products

        if (products.count != 0) {
            product = products[0]
            buyButton.isEnabled = true
            productTitle.text = product!.localizedTitle
            productDescription.text = product!.localizedDescription

        } else {
                productTitle.text = "Product not found"
        }

        let invalids = response.invalidProductIdentifiers

        for product in invalids
        {
             print("Product not found: \(product)")
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {

            switch transaction.transactionState {

            case SKPaymentTransactionState.purchased:
                self.unlockFeature()
                SKPaymentQueue.default().finishTransaction(transaction)

            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }

    func unlockFeature() {
        let appdelegate = UIApplication.shared.delegate
                                    as! AppDelegate

        appdelegate.homeViewController!.enableLevel2()
        buyButton.isEnabled = false
        productTitle.text = "Item has been purchased"
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
