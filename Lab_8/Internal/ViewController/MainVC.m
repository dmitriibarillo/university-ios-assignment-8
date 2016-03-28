#import "MainVC.h"
#import "TableVC.h"
#import "Repository.h"
#import "GitHubAPIController.h"
#import "NSString+LoginHelper.h"
#import <AFNetworking.h>

@interface MainVC () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic) UIView *grayView;
@property (nonatomic) GitHubAPIController *controller;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controller = [GitHubAPIController sharedController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)searchButtonTaped {
    [self showGrayView];
    [self loadData];
}

- (void)loadData
{
    NSString *user = self.textField.text;
    typeof(self) __weak wself = self;
    
    [self.controller
     getReposInfoForUser:user
     success:^(NSArray *objects) {
         
         TableVC *tableVC = [[TableVC alloc] initWithData:objects];
         [wself.navigationController pushViewController:tableVC animated:YES];
         [wself.grayView removeFromSuperview];
     }
     failure:^(NSError *error) {
         NSHTTPURLResponse* httpResponseErrorKey = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
         NSInteger htmlStatusCode = httpResponseErrorKey.statusCode;
         
         if (error.code ==  NSURLErrorTimedOut && [error.domain isEqualToString:NSURLErrorDomain]) {
             NSString *message = [NSString stringWithFormat:@"The Internet connection timed out."];
             [wself showAlertWithErrorCode:error.code andMessage:message];
         }
         else if (error.code ==  NSURLErrorNotConnectedToInternet) {
             NSString *message = [NSString stringWithFormat:@"The Internet connection appears to be offline."];
             [wself showAlertWithErrorCode:error.code andMessage:message];
         }
         else if (htmlStatusCode == 404) {
             NSString *message = [NSString stringWithFormat:@"User with name \'%@\' doesn't exist.", user];
             [wself showAlertWithErrorCode:error.code andMessage:message];
         }
         else {
             NSString *message = [NSString stringWithFormat:@"Error %@.", error.localizedDescription];
             [wself showAlertWithErrorCode:error.code andMessage:message];
             NSLog(@"Error: %@", error.description);
         }
         [wself.grayView removeFromSuperview];
     }];
}

- (void)showAlertWithErrorCode:(NSInteger)code andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
        initWithTitle:[NSString stringWithFormat:@"Error %ld",(long)code]
        message:[NSString stringWithString:message]
        delegate:nil
        cancelButtonTitle:@"Close"
        otherButtonTitles:nil];
    
    [alert show];
}

- (void)showGrayView
{
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:self.grayView];

    UIActivityIndicatorView *i= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    i.center = self.grayView.center;
    [i startAnimating];
    [self.grayView addSubview:i];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchButtonTaped];
    [textField resignFirstResponder];
 
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([resultString isEqual:@""]) {
        return YES;
    }
    else {
        return [NSString isValidLogin:resultString];
    }
}

@end
