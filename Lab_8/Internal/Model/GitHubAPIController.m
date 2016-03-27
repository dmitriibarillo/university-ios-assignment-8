#import "GitHubAPIController.h"
#import <AFNetworking.h>
#import "Repository.h"

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

- (void)getReposInfoForUser:(NSString *)user
        success:(void (^)(NSArray *))success
        failure:(void (^)(NSError *))failure
{
    NSString *request = [NSString stringWithFormat:@"users/%@/repos", user];
    NSString *encodeRequest = [request stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    
    [self.sessionManager
        GET:encodeRequest
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                
                NSMutableArray *result = [[NSMutableArray alloc] init];
                NSArray *keys = @[kRepositoryName, kRepositoryCreatedAt, kRepositoryUpdatedAt];
                for (NSDictionary *dict in responseObject) {
                    Repository *repository = [[Repository alloc] init];
                    
                    for (NSString *key in keys) {
                        [repository setValue:dict[key] forKey:key];
                    }
                    
                    [result addObject:repository];
                }
                
                success(result);
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
}

@end
