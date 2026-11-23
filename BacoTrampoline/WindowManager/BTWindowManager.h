
#import <UIKit/UIKit.h>
#import "BTWindow.h"

FOUNDATION_EXPORT NSString * const BTWindowManagerDidChangeNotification;

@interface BTWindowManager : NSObject

@property (nonatomic, assign, readonly) NSInteger currentWorkspace;

@property (nonatomic, copy, readonly) NSArray<BTWindow *> *windows;

+ (instancetype)sharedManager;

- (BTWindow *)openWindowWithTitle:(NSString *)title
                            frame:(CGRect)frame;

- (void)closeWindow:(BTWindow *)window;

- (void)minimizeWindow:(BTWindow *)window;

- (void)toggleMaximizeWindow:(BTWindow *)window
                withinBounds:(CGRect)bounds;

- (void)moveWindow:(BTWindow *)window
           toFrame:(CGRect)frame;

- (void)bringWindowToFront:(BTWindow *)window;

- (void)switchToWorkspace:(NSInteger)workspace;

- (NSArray<BTWindow *> *)windowsForWorkspace:(NSInteger)workspace;

@end
