//
//  ReadingsViewController.swift
//  PDM-MobileHub
//
//  Created by Nick Grah on 1/21/18.
//  Copyright © 2018 PDM. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore

class ReadingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    var Timestamp = String()
    
    func generate_timestamp() {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        // December 20, 2017 at 11:30pm exactly would be "20-12-2017 23:30:00"
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        var dateString = dateFormatter.string(from: currentDate as Date)
        Timestamp = dateString
    }
    
    
//********************************************************************************

    func uploadReading() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let reading: Readings = Readings()
        
        reading._userId = AWSIdentityManager.default().identityId
        
        generate_timestamp()
        
        reading._timestamp = Timestamp
        reading._fEF = 1
        reading._fEV75 = 1
        reading._fEV1 = 1
        reading._fEV1Best = 0
        reading._fEV6 = 1
        reading._pEF = 1
        reading._pEFBest = 0
        reading._colorRating = "yellow"
        reading._goodBlow = 0
        
        
        //Save a new item
        dynamoDbObjectMapper.save(reading, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A reading item was saved.")
        })
    }
    
//********************************************************************************
    
    func downloadReading() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let reading: Readings = Readings();
        reading._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.load(
            Readings.self,
            hashKey: reading._userId,
            rangeKey: "timestamp_of_target_reading",
            completionHandler: {
                (objectModel: AWSDynamoDBObjectModel?, error: Error?) -> Void in
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    return
                }
                print("A reading item was read.")
        })
    }
    
//********************************************************************************
    
    func updateReading() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let reading: Readings = Readings()
        
        reading._userId = AWSIdentityManager.default().identityId
        
        //reading._timestamp = NSDate().timeIntervalSince1970 as NSNumber
        
        reading._timestamp = "timestamp_of_reading_to_edit"
        reading._fEF = 1
        reading._fEV75 = 2
        reading._fEV1 = 3
        reading._fEV1Best = 1
        reading._fEV6 = 5
        reading._pEF = 6
        reading._pEFBest = 1
        reading._colorRating = "green"
        reading._goodBlow = 1
        
        dynamoDbObjectMapper.save(reading, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A reading item was updated.")
        })
    }
    
//********************************************************************************
    
    func deleteReading() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToDelete = Readings()
        itemToDelete?._userId = AWSIdentityManager.default().identityId
        itemToDelete?._timestamp = "timestamp_of_reading_to_delete"
        
        dynamoDbObjectMapper.remove(itemToDelete!, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A reading item was deleted.")
        })
    }
    
//********************************************************************************
    
    // NOTE: I have not finalized these values yet, still figuring it out
    
    func queryReading() {
        // 1) Configure the query
        let queryExpression = AWSDynamoDBQueryExpression()
        //queryExpression.keyConditionExpression = "#articleId >= :articleId AND #userId = :userId"
        queryExpression.keyConditionExpression = "#timestamp >= :timestamp AND #userId = :userId"
        
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#timestamp": "timestamp"
        ]
        queryExpression.expressionAttributeValues = [
            ":timestamp": "a_target_timestamp",
            ":userId": AWSIdentityManager.default().identityId
        ]
        
        // 2) Make the query
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.query(Readings.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                for reading in output!.items {
                    let reading = reading as? Readings
                    print("\(reading!._timestamp!)")
                }
            }
        }
    }
    
//********************************************************************************
}
