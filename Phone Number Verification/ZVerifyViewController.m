//
//  ZVerifyViewController.m
//  Phone Number Verification
//
//  Created by fmohamed on 3/26/20.
//  Copyright © 2020 practice. All rights reserved.
//

#import "ZVerifyViewController.h"
#import "ZDBManager.h"
#import "Reachability.h"
#import "ZTableViewController.h"

@interface ZVerifyViewController ()
@end

@implementation ZVerifyViewController

Boolean firstEntry= TRUE;
NSArray* APIJsonResponse;
Reachability *internetReachableFoo;
Boolean internetConnectivity;
NSString *numberFieldTxt;
ZTableViewController *tableViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dbManager = [[ZDBManager alloc] initWithDatabaseFilename:@"numVerifyDB.sql"];
    _tableSubView.hidden=YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClick:(id)sender {
    NSLog(@"validate is tapped");
    numberFieldTxt= _numberField.text;
    if (numberFieldTxt.length==0) return;
    NSLog(@"Entered text is%@ ", numberFieldTxt);

    _validateBtn.enabled= NO;
    NSLog(@"button is disabled");

    //Run API connection in background thread
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        NSLog(@"Background dispatch for API connection started.. ");
        @try{
            [self connectAPI:numberFieldTxt];

        }
        @catch(NSException* exception){
            NSLog(@"API Connection caused  %@", exception);
        }
    });
    //Some logic waits for API connection to finish
    dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
        NSLog(@"API connection finished with result%@",APIJsonResponse);
        @try{
            self->_verification_details = [self detailsArrayFromJSON:APIJsonResponse];
        }
        @catch(NSException* exception){
            NSLog(@"exception from parsing is %@", exception);
        }
        
        if (firstEntry){
            [self animateTextField:self.numberField up:YES];
            [self animateButton:self.validateBtn];
             self.tableSubView.hidden=NO;
        }
        firstEntry= NO;
        self.validateBtn.enabled= YES;
//show verification details from verifyViewController in tableViewController
//        [self performSegueWithIdentifier:@"showDetailSegue" sender:@""];
       


    });
}

-(NSArray*) detailsArrayFromJSON:(NSArray*) array{
    return [NSArray arrayWithObjects:
            ([[array valueForKey:@"valid"] boolValue]==NO)?@"invalid":@"valid",
            [array valueForKey:@"number"],
            [array valueForKey:@"location"],
            [array valueForKey:@"local_format"],
            ([ [array valueForKey:@"line_type"] isEqual:[NSNull null]])?@" ":
            [array valueForKey:@"line_type"],
            [array valueForKey:@"international_format"],
            [array valueForKey:@"country_prefix"],
            [array valueForKey:@"country_name"],
            [array valueForKey:@"country_code"],
            [array valueForKey:@"carrier"],
            nil];
}
-(void)connectAPI:(NSString*)number{
    NSError *error;
    NSString* url_string =@"http://apilayer.net/api/validate\?access_key=77e13fdfd838ada1f446be41e6f767f6&number=";
    url_string = [url_string stringByAppendingString:number];
    url_string= [url_string stringByAppendingString:@"&country_code=&format=1"];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    APIJsonResponse= json;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // verify the text field you wanna validate
    if (textField == _numberField) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }

        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }

        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 30) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"];
        
        if ([string rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
        
    }
   return YES;
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    //Moves text field to the top of the screen
    CGRect frame = textField.frame;
    frame.origin.x = 20; // new x
    frame.origin.y = 140; // new y
    textField.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)numberFieldEditEnded:(id)sender {
    NSLog(@"Edit Ended");

}
-(void)animateButton:(UIButton*)btn{
    //Moves button relative to the text field
    CGRect numberFieldFrame= _numberField.frame;
    CGRect BtnFrame = btn.frame;
    btn.frame= CGRectOffset(numberFieldFrame,numberFieldFrame.size.width/2+BtnFrame.size.width/2 +20, 0);
    [UIView commitAnimations];
}

-(void)NoInternetConnectionalert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Internet Connection Error"
                                                                   message:@"Please make sure you have internet access."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                         }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)testInternetConnection
{
   
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability* reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            internetConnectivity= YES;
        });
        
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability* reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            internetConnectivity= NO;
        });
    };
    
    [internetReachableFoo startNotifier];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //BUG: that causes tableView to fill all the screen
    NSLog(@"prepareForSegue is called");
    if([segue.identifier isEqualToString:@"showDetailSegue"]){
        ZTableViewController *controller = (ZTableViewController*)segue.destinationViewController;
        controller.data= _verification_details ;
    }
}

-(void):NavigateToTableViewController{
    //That make tableView fits into its containerView but does not display data in table cells
            tableViewController =[ZTableViewController alloc];
    
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
            [navController.view setFrame:CGRectMake(0.0f, 0.0f, self->_tableSubView.frame.size.width, self->_tableSubView.frame.size.height)];
    
            [self->_tableSubView addSubview:navController.view];
    
            [self addChildViewController:navController];
    
            [navController didMoveToParentViewController:self];
            tableViewController.data= self->_verification_details;

}
@end
