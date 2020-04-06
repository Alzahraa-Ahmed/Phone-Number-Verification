//
//  ZDBManager.h
//  Phone Number Verification
//
//  Created by fmohamed on 3/29/20.
//  Copyright © 2020 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDBManager : NSObject
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(void)copyDatabaseIntoDocumentsDirectory;
@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;
-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end

NS_ASSUME_NONNULL_END
