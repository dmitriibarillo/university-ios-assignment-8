#import "TableVC.h"
#import "CustomCell.h"
#import "Repository.h"

static NSString *const reuseId = @"reuseId";

@interface TableVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([CustomCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseId];
    self.tableView.estimatedRowHeight = 100;
    
    self.navigationController.navigationBar.hidden = NO;
}

- (instancetype)initWithData:(NSArray *)data{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _data = [NSArray arrayWithArray:data];
    }
    
    return self;
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
    cell.authorLabel.text = userInfo.createdDate;
    cell.commitLabel.text = userInfo.updatedDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
