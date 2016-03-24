#import <Foundation/Foundation.h>

static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryLastCommitter = @"lastCommitter";
static NSString *const kRepositoryCommitsCount = @"commitsCount";

@interface Repository : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *lastCommitter;
@property (nonatomic) NSInteger *commitsCount;

@end
