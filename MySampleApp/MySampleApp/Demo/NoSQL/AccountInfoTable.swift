//
//  AccountInfoTable.swift
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
import AWSAuthCore

class AccountInfoTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var partitionKeyType: String
    var sortKeyName: String?
    var sortKeyType: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {

        return "Account_info"
    }
    
    override init() {

        model = AccountInfo()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        partitionKeyType = "String"
        indexes = [

            AccountInfoPrimaryIndex(),
        ]
        if let sortKeyNamePossible = model.classForCoder.rangeKeyAttribute?() {
            sortKeyName = sortKeyNamePossible
            sortKeyType = "String"
        }
        super.init()
    }
    
    /**
     * Converts the attribute name from data object format to table format.
     *
     * - parameter dataObjectAttributeName: data object attribute name
     * - returns: table attribute name
     */

    func tableAttributeName(_ dataObjectAttributeName: String) -> String {
        return AccountInfo.jsonKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    func getItemDescription() -> String {
        let hashKeyValue = AWSIdentityManager.default().identityId!
        let rangeKeyValue = "demo-accountName-500000"
        return "Find Item with userId = \(hashKeyValue) and accountName = \(rangeKeyValue)."
    }
    
    func getItemWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBObjectModel?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(AccountInfo.self, hashKey: AWSIdentityManager.default().identityId!, rangeKey: "demo-accountName-500000") { (response: AWSDynamoDBObjectModel?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func scanDescription() -> String {
        return "Show all items in the table."
    }
    
    func scanWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 5

        objectMapper.scan(AccountInfo.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func scanWithFilterDescription() -> String {
        let scanFilterValue = "demo-firstName-500000"
        return "Find all items with firstName < \(scanFilterValue)."
    }
    
    func scanWithFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#firstName < :firstName"
        scanExpression.expressionAttributeNames = ["#firstName": "firstName" ,]
        scanExpression.expressionAttributeValues = [":firstName": "demo-firstName-500000" ,]

        objectMapper.scan(AccountInfo.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func insertSampleDataWithCompletionHandler(_ completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        let numberOfObjects = 20
        

        let itemForGet: AccountInfo! = AccountInfo()
        
        itemForGet._userId = AWSIdentityManager.default().identityId!
        itemForGet._accountName = "demo-accountName-500000"
        itemForGet._firstName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("firstName")
        itemForGet._friends = NoSQLSampleDataGenerator.randomSampleStringArray()
        itemForGet._lastName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("lastName")
        itemForGet._profilePhoto = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("profilePhoto")
        
        
        group.enter()
        

        objectMapper.save(itemForGet, completionHandler: {(error: Error?) -> Void in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        
        for _ in 1..<numberOfObjects {

            let item: AccountInfo = AccountInfo()
            item._userId = AWSIdentityManager.default().identityId!
            item._accountName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("accountName")
            item._firstName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("firstName")
            item._friends = NoSQLSampleDataGenerator.randomSampleStringArray()
            item._lastName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("lastName")
            item._profilePhoto = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("profilePhoto")
            
            group.enter()
            
            objectMapper.save(item, completionHandler: {(error: Error?) -> Void in
                if error != nil {
                    DispatchQueue.main.async(execute: {
                        errors.append(error! as NSError)
                    })
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            if errors.count > 0 {
                completionHandler(errors)
            }
            else {
                completionHandler(nil)
            }
        })
    }
    
    func removeSampleDataWithCompletionHandler(_ completionHandler: @escaping ([NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]

        objectMapper.query(AccountInfo.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    completionHandler([error]);
                    })
            } else {
                var errors: [NSError] = []
                let group: DispatchGroup = DispatchGroup()
                for item in response!.items {
                    group.enter()
                    objectMapper.remove(item, completionHandler: {(error: Error?) in
                        if let error = error as? NSError {
                            DispatchQueue.main.async(execute: {
                                errors.append(error)
                            })
                        }
                        group.leave()
                    })
                }
                group.notify(queue: DispatchQueue.main, execute: {
                    if errors.count > 0 {
                        completionHandler(errors)
                    }
                    else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    func updateItem(_ item: AWSDynamoDBObjectModel, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        

        let itemToUpdate: AccountInfo = item as! AccountInfo
        
        itemToUpdate._firstName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("firstName")
        itemToUpdate._friends = NoSQLSampleDataGenerator.randomSampleStringArray()
        itemToUpdate._lastName = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("lastName")
        itemToUpdate._profilePhoto = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("profilePhoto")
        
        objectMapper.save(itemToUpdate, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(error as? NSError)
            })
        })
    }
    
    func removeItem(_ item: AWSDynamoDBObjectModel, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.remove(item, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(error as? NSError)
            })
        })
    }
}

class AccountInfoPrimaryIndex: NSObject, Index {
    
    var indexName: String? {
        return nil
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        return "Find all items with userId = \(partitionKeyValue)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]

        objectMapper.query(AccountInfo.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        let filterAttributeValue = "demo-firstName-500000"
        return "Find all items with userId = \(partitionKeyValue) and firstName > \(filterAttributeValue)."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.filterExpression = "#firstName > :firstName"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#firstName": "firstName",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId!,
            ":firstName": "demo-firstName-500000",
        ]
        

        objectMapper.query(AccountInfo.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        let sortKeyValue = "demo-accountName-500000"
        return "Find all items with userId = \(partitionKeyValue) and accountName < \(sortKeyValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #accountName < :accountName"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#accountName": "accountName",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId!,
            ":accountName": "demo-accountName-500000",
        ]
        

        objectMapper.query(AccountInfo.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        let sortKeyValue = "demo-accountName-500000"
        let filterValue = "demo-firstName-500000"
        return "Find all items with userId = \(partitionKeyValue), accountName < \(sortKeyValue), and firstName > \(filterValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #accountName < :accountName"
        queryExpression.filterExpression = "#firstName > :firstName"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#accountName": "accountName",
            "#firstName": "firstName",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId!,
            ":accountName": "demo-accountName-500000",
            ":firstName": "demo-firstName-500000",
        ]
        

        objectMapper.query(AccountInfo.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
}
