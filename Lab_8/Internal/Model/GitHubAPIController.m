#import "GitHubAPIController.h"
#import <AFNetworking.h>

// https://api.github.com/users/noveogroup/repos

// https://api.github.com/repos/dmitriibarillo/JSONParser/commits

static NSString *const kBaseAPIURL = @"https://api.github.com";

@interface GitHubAPIController ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation GitHubAPIController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
    }
    
    return self;
}

+ (instancetype)sharedController
{
    static GitHubAPIController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[GitHubAPIController alloc] init];
    });
    
    return sharedController;
}

- (void)getInfoForUser:(NSString *)userName
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure
{
    NSString *request = [NSString stringWithFormat:@"users/%@/repos", userName];
    
    [self.sessionManager
        GET:request
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(responseObject);
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
}

@end
