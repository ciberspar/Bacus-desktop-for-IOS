
#import "BDWindowManager.h"
#import "../Interface/BDDesktopView.h"

@interface BDRootViewController : UIViewController
@end

@implementation BDRootViewController

- (void)loadView {
    self.view = [[BDDesktopView alloc]
        initWithFrame:UIScreen.mainScreen.bounds];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

@implementation BDWindowManager

static UIWindow *desktopWindow;

+ (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (desktopWindow != nil) {
            return;
        }

        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in
                 UIApplication.sharedApplication.connectedScenes) {

                if (![scene isKindOfClass:
                      [UIWindowScene class]]) {
                    continue;
                }

                UIWindowScene *windowScene =
                    (UIWindowScene *)scene;

                if (windowScene.activationState !=
                    UISceneActivationStateForegroundActive) {
                    continue;
                }

                desktopWindow =
                    [[UIWindow alloc]
                     initWithWindowScene:windowScene];

                break;
            }
        }

        if (desktopWindow == nil) {
            desktopWindow =
                [[UIWindow alloc]
                 initWithFrame:UIScreen.mainScreen.bounds];
        }

        desktopWindow.rootViewController =
            [[BDRootViewController alloc] init];

        desktopWindow.windowLevel =
            UIWindowLevelNormal + 1;

        [desktopWindow makeKeyAndVisible];
    });
}

@end
