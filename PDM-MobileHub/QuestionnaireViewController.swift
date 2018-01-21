//
//  QuestionnaireViewController.swift
//  PDM-MobileHub
//
//  Created by Nick Grah on 1/21/18.
//  Copyright © 2018 PDM. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore


class QuestionnaireViewController: UIViewController {

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
    
    func uploadQuestionnaire() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let questionnaire: Questionnaire = Questionnaire()
        
        questionnaire._userId = AWSIdentityManager.default().identityId
        
        generate_timestamp()
        
        questionnaire._timestamp = Timestamp
        questionnaire._question1 = 1
        questionnaire._question2 = 1
        questionnaire._question3 = 1
        questionnaire._question4 = 1
        questionnaire._question5 = 1
        questionnaire._question6 = 1
        questionnaire._question7 = 1
        questionnaire._question8 = 1
        //questionnaire._total = (questionnaire._question1 + questionnaire._question2 + questionnaire._question3 + questionnaire._question4 + questionnaire._question5 + questionnaire._question6 + questionnaire._question7 + questionnaire._question8)
        questionnaire._total = 8

        //Save a new item
        dynamoDbObjectMapper.save(questionnaire, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A questionnaire item was saved.")
        })
    }
    
    //********************************************************************************
    
    func downloadQuestionnaire() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let questionnaire: Questionnaire = Questionnaire()
        questionnaire._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.load(
            Questionnaire.self,
            hashKey: questionnaire._userId,
            rangeKey: "timestamp_of_target_questionnaire",
            completionHandler: {
                (objectModel: AWSDynamoDBObjectModel?, error: Error?) -> Void in
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    return
                }
                print("A questionnaire item was read.")
        })
    }
    
    //********************************************************************************
    
    func updateQuestionnaire() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let questionnaire: Questionnaire = Questionnaire()
        
        questionnaire._userId = AWSIdentityManager.default().identityId
        
        questionnaire._timestamp = "timestamp_of_questionnaire_to_edit"
        questionnaire._question1 = 1
        questionnaire._question2 = 2
        questionnaire._question3 = 3
        questionnaire._question4 = 4
        questionnaire._question5 = 5
        questionnaire._question6 = 4
        questionnaire._question7 = 3
        questionnaire._question8 = 2
        //questionnaire._total = (questionnaire._question1 + questionnaire._question2 + questionnaire._question3 + questionnaire._question4 + questionnaire._question5 + questionnaire._question6 + questionnaire._question7 + questionnaire._question8)
        questionnaire._total = 24
        
        dynamoDbObjectMapper.save(questionnaire, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A questionnaire item was updated.")
        })
    }
    
    //********************************************************************************
    
    func deleteQuestionnaire() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToDelete = Questionnaire()
        itemToDelete?._userId = AWSIdentityManager.default().identityId
        itemToDelete?._timestamp = "timestamp_of_questionnaire_to_delete"
        
        dynamoDbObjectMapper.remove(itemToDelete!, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A questionnaire item was deleted.")
        })
    }
    
    //********************************************************************************
    
    // NOTE: I have not finalized these values yet, still figuring it out
    
    func queryQuestionnaire() {
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
        
        dynamoDbObjectMapper.query(Questionnaire.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                for questionnaire in output!.items {
                    let questionnaire = questionnaire as? Questionnaire
                    print("\(questionnaire!._timestamp!)")
                }
            }
        }
    }
    
    //********************************************************************************

}
