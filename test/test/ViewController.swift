//
//  ViewController.swift
//  test
//
//  Created by Minghong Zhou on 11/16/17.
//  Copyright © 2017 Minghong Zhou. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSDynamoDB

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func add(_ sender: UIButton) {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        //Create data object using data models you downloaded from Mobile Hub
        let transactionsItem = Transanctions();
        
        // Use AWSIdentityManager.default().identityId here to get the user identity id.
        transactionsItem?._transactionId = "demo-transactionId-666"
        transactionsItem?._transactionDate = "demo-transactionDate-040427"
        transactionsItem?._borrower = 1111000002
        transactionsItem?._lender = 1111000003
        
        //Save a new item
        dynamoDbObjectMapper.save(transactionsItem!, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
    }
    
}

