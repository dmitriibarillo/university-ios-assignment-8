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

- (IBAction)searchButtonTaped {
    [self showGrayView];
    [self loadRepositoryData];
}

- (void)loadRepositoryData
{
    NSString *user = self.textField.text;
    typeof(self) __weak wself = self;
    
    __block NSArray *repositories;
    
    [self.controller
     getInfoForUser:user
     success:^(NSArray *objects) {
         repositories = [wself generateRepositoriesFromDictionaries:objects];
         
         TableVC *tableVC = [[TableVC alloc] initWithData:repositories];
         [wself presentViewController:tableVC animated:YES completion:nil];
         
         [wself.grayView removeFromSuperview];
     }
     failure:^(NSError *error) {
         if (error.code == -1009) {
             NSString *message = [NSString stringWithFormat:@"The Internet connection appears to be offline."];
             [self showAlertWithErrorCode:error.code andMessage:message];
         }
         else if (error.code == -1011) {
             NSString *message = [NSString stringWithFormat:@"User with name \'%@\' doesn't exist.",user];
             [self showAlertWithErrorCode:error.code andMessage:message];
         }
         else {
             NSLog(@"Error: %@", error);
         }
         [self.grayView removeFromSuperview];
     }];
}

- (NSArray *)generateRepositoriesFromDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *repositories = [NSMutableArray array];
    for (NSDictionary *dict in dictionaries) {
        Repository *repository = [[Repository alloc] init];
        repository.name = dict[kRepositoryName];
        repository.commitsCount = 0;
        [repositories addObject:repository];
    }
    
    return repositories;
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


@end
