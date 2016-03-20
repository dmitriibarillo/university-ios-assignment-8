#import "TableVC.h"

@interface TableVC ()

@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationBar.topItem.title = @"SomeTitle";    
}

- (void)initializeComponents
{
    NSString *backBarButtonName = @"Back";
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithTitle:backBarButtonName style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
    self.navigationBar.topItem.leftBarButtonItem = backBarItem;

}

- (void)backButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
