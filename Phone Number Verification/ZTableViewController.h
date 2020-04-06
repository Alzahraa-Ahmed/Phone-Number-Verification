//
//  ZTableViewController.h
//  Phone Number Verification
//
//  Created by fmohamed on 3/26/20.
//  Copyright © 2020 practice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *headers;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *str;
@end

NS_ASSUME_NONNULL_END
