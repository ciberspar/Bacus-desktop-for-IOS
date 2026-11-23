
#import <UIKit/UIKit.h>
#import "../BacusDesktop/BDDesktopViewController.h"

@interface BDAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation BDAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    self.window.rootViewController =
        [[BDDesktopViewController alloc] init];

    [self.window makeKeyAndVisible];

    return YES;
}

@end
