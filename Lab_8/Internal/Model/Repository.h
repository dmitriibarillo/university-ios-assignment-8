#import <Foundation/Foundation.h>

static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryCreatedAt = @"created_at";
static NSString *const kRepositoryUpdatedAt = @"updated_at";

@interface Repository : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *created_at;
@property (nonatomic) NSString *updated_at;

@end
