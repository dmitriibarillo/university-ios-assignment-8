#import <Foundation/Foundation.h>

static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryCreatedAt = @"created_at";
static NSString *const kRepositoryUpdatedAt = @"updated_at";

@interface Repository : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *createdDate;
@property (nonatomic) NSString *updatedDate;

@end
