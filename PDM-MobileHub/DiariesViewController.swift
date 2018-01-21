//
//  DiariesViewController.swift
//  PDM-MobileHub
//
//  Created by Nick Grah on 1/21/18.
//  Copyright © 2018 PDM. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore

class DiariesViewController: UIViewController {

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
    
    func uploadDiary() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let diary: Diaries = Diaries()
        
        diary._userId = AWSIdentityManager.default().identityId
        
        generate_timestamp()
        
        diary._timestamp = Timestamp
        diary._question1 = 1
        diary._question2 = 1
        diary._question3 = 1
        diary._question4 = 1
        diary._question5 = 1
        //diary._total = Int(diary._question1) + Int(diary._question2) + Int(diary._question3) + Int(diary._question4) + Int(diary._question5)
        diary._total = 5
        
        //Save a new item
        dynamoDbObjectMapper.save(diary, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A diary item was saved.")
        })
    }
    
    //********************************************************************************
    
    func downloadDiary() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let diary: Diaries = Diaries()
        diary._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.load(
            Diaries.self,
            hashKey: diary._userId,
            rangeKey: "timestamp_of_target_diary",
            completionHandler: {
                (objectModel: AWSDynamoDBObjectModel?, error: Error?) -> Void in
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    return
                }
                print("A diary item was read.")
        })
    }
    
    //********************************************************************************
    
    func updateDiary() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let diary: Diaries = Diaries()
        
        diary._userId = AWSIdentityManager.default().identityId
        
        diary._timestamp = "timestamp_of_diary_to_edit"
        diary._question1 = 1
        diary._question2 = 2
        diary._question3 = 3
        diary._question4 = 4
        diary._question5 = 5
        //diary._total = (diary._question1 + diary._question2 + diary._question3 + diary._question4 + diary._question5)
        diary._total = 15
        
        dynamoDbObjectMapper.save(diary, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A diary item was updated.")
        })
    }
    
    //********************************************************************************
    
    func deleteDiary() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToDelete = Diaries()
        itemToDelete?._userId = AWSIdentityManager.default().identityId
        itemToDelete?._timestamp = "timestamp_of_diary_to_delete"
        
        dynamoDbObjectMapper.remove(itemToDelete!, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A diary item was deleted.")
        })
    }
    
    //********************************************************************************
    
    // NOTE: I have not finalized these values yet, still figuring it out
    
    func queryDiary() {
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
        
        dynamoDbObjectMapper.query(Diaries.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                for diary in output!.items {
                    let diary = diary as? Diaries
                    print("\(diary!._timestamp!)")
                }
            }
        }
    }
    
    //********************************************************************************

}
