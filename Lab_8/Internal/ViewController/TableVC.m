#import "TableVC.h"

@interface TableVC ()

@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
