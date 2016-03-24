#import "TableVC.h"
#import "CustomCell.h"
#import "Repository.h"

static NSString *const reuseId = @"reuseId";
static NSString *const kNameKey = @"nameKey";
static NSString *const kCapitalKey = @"capitalKey";

@interface TableVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponents];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([CustomCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseId];
    self.tableView.estimatedRowHeight = 100;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    Repository *userInfo = self.data[indexPath.row];
    
    cell.titleLabel.text = userInfo.name;
    cell.authorLabel.text = userInfo.lastCommitter;
    cell.commitLabel.text = [NSString stringWithFormat:@"Total commits: %lu", userInfo.commitsCount];
    
    return cell;
}

- (void)backButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)initWithData:(NSArray *)data
{
    self = [super self];
    if (self) {
        _data = [NSArray arrayWithArray:data];
    }
    
    return self;
}

@end
