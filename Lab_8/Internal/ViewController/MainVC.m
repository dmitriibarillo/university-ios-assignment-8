#import "MainVC.h"
#import "TableVC.h"
#import "Repository.h"
#import "GitHubAPIController.h"

@interface MainVC () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@property (nonatomic) IBOutlet UIView *grayView;
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
         if (error.code ==  kCFURLErrorTimedOut) {
             NSString *message = [NSString stringWithFormat:@"The Internet connection timed out."];
             [self showAlertWithErrorCode:error.code andMessage:message];
         }
         if (error.code ==  kCFURLErrorNotConnectedToInternet) {
             NSString *message = [NSString stringWithFormat:@"The Internet connection appears to be offline."];
             [self showAlertWithErrorCode:error.code andMessage:message];
         }
         else if (error.code == kCFURLErrorBadServerResponse) {
             NSString *message = [NSString stringWithFormat:@"User with name \'%@\' doesn't exist.",user];
             [self showAlertWithErrorCode:error.code andMessage:message];
         }
         else {
             NSLog(@"Error: %@", error);
         }
         [self.grayView removeFromSuperview];
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
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@".,/\\!@#$%^&*()_+= "];
    
    if ([resultString rangeOfCharacterFromSet:characterSet].length != 0) {
        return NO;
    }
    
    return YES;
}

@end
