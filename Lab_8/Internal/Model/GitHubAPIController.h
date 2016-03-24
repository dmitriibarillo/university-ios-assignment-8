#import <Foundation/Foundation.h>

@interface GitHubAPIController : NSObject

+ (instancetype)sharedController;

- (void)getInfoForUser:(NSString *)userName
       success:(void (^)(NSArray *))success
       failure:(void (^)(NSError *))failure;

@end
