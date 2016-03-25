#import <Foundation/Foundation.h>

@interface GitHubAPIController : NSObject

+ (instancetype)sharedController;

- (void)getReposInfoForUser:(NSString *)user
        success:(void (^)(NSArray *))success
        failure:(void (^)(NSError *))failure;

@end
