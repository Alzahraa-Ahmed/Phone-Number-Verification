//
//  ZVerifyViewController.h
//  Phone Number Verification
//
//  Created by fmohamed on 3/26/20.
//  Copyright © 2020 practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDBManager.h"
#import "ZUITextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZVerifyViewController : UIViewController
- (IBAction)btnClick:(id)sender;
@property (nonatomic, retain) NSArray* verification_details;
- (void)connectAPI:(NSString*)number;
@property (nonatomic, strong) ZDBManager *dbManager;
@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UIView *tableSubView;
- (IBAction)numberFieldEditEnded:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *validateBtn;


@end

NS_ASSUME_NONNULL_END
