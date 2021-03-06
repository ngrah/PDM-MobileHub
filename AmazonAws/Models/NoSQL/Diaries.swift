//
//  Diaries.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB

class Diaries: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _timestamp: String?
    var _question1: NSNumber?
    var _question2: NSNumber?
    var _question3: NSNumber?
    var _question4: NSNumber?
    var _question5: NSNumber?
    var _total: NSNumber?
    
    class func dynamoDBTableName() -> String {

        return "pdm-mobilehub-1919196700-Diaries"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_timestamp"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_timestamp" : "timestamp",
               "_question1" : "question1",
               "_question2" : "question2",
               "_question3" : "question3",
               "_question4" : "question4",
               "_question5" : "question5",
               "_total" : "total",
        ]
    }
}
