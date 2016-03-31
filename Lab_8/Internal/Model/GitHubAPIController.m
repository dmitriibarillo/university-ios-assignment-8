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
    NSString *encodeUser = [user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];;
    NSString *request = [NSString stringWithFormat:@"users/%@/repos", encodeUser];
    
    [self.sessionManager
        GET:request
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseObject) {
                    Repository *repository = [[Repository alloc] init];
                    repository.name = dict[kRepositoryName];
                    repository.createdDate = dict[kRepositoryCreatedAt];
                    repository.updatedDate = dict[kRepositoryUpdatedAt];
                    
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
