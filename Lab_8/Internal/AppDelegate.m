#import "AppDelegate.h"
#import "MainVC.h"
#import "TableVC.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:mainFrame];
    
    MainVC *mainVC= [[MainVC alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
