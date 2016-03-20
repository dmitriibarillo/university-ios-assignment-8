#import "MainVC.h"
#import "TableVC.h"

@interface MainVC () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)searchButtonTaped:(id)sender {
    TableVC *tablePage = [[TableVC alloc] init];
    [self presentViewController:tablePage animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
