
#import "BTWindowManager.h"

NSString * const BTWindowManagerDidChangeNotification =
    @"BTWindowManagerDidChangeNotification";

@interface BTWindowManager ()

@property (nonatomic, assign, readwrite) NSInteger currentWorkspace;
@property (nonatomic, strong) NSMutableArray<BTWindow *> *mutableWindows;
@property (nonatomic, assign) NSInteger nextZIndex;

@end

@implementation BTWindowManager

+ (instancetype)sharedManager {
    static BTWindowManager *manager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[BTWindowManager alloc] init];
    });

    return manager;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _mutableWindows = [NSMutableArray array];
        _currentWorkspace = 1;
        _nextZIndex = 1;
    }

    return self;
}

- (NSArray<BTWindow *> *)windows {
    return [self.mutableWindows copy];
}

- (void)notifyChange {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:BTWindowManagerDidChangeNotification
                      object:self];
}

- (BTWindow *)openWindowWithTitle:(NSString *)title
                            frame:(CGRect)frame {

    BTWindow *window = [[BTWindow alloc]
        initWithTitle:title
                frame:frame
            workspace:self.currentWorkspace];

    window.zIndex = self.nextZIndex++;

    [self.mutableWindows addObject:window];

    [self notifyChange];

    return window;
}

- (void)closeWindow:(BTWindow *)window {
    if (!window || ![self.mutableWindows containsObject:window]) {
        return;
    }

    [self.mutableWindows removeObject:window];

    [self notifyChange];
}

- (void)minimizeWindow:(BTWindow *)window {
    if (!window || ![self.mutableWindows containsObject:window]) {
        return;
    }

    window.state = BTWindowStateMinimized;
    window.visible = NO;

    [self notifyChange];
}

- (void)toggleMaximizeWindow:(BTWindow *)window
                withinBounds:(CGRect)bounds {

    if (!window || ![self.mutableWindows containsObject:window]) {
        return;
    }

    if (window.state == BTWindowStateMaximized) {
        window.frame = window.restoreFrame;
        window.state = BTWindowStateNormal;
    } else {
        if (window.state == BTWindowStateNormal) {
            window.restoreFrame = window.frame;
        }

        window.frame = bounds;
        window.state = BTWindowStateMaximized;
    }

    window.visible = YES;

    [self bringWindowToFront:window];
    [self notifyChange];
}

- (void)moveWindow:(BTWindow *)window
           toFrame:(CGRect)frame {

    if (!window || ![self.mutableWindows containsObject:window]) {
        return;
    }

    if (window.state == BTWindowStateMaximized) {
        return;
    }

    window.frame = frame;
    window.restoreFrame = frame;

    [self notifyChange];
}

- (void)bringWindowToFront:(BTWindow *)window {
    if (!window || ![self.mutableWindows containsObject:window]) {
        return;
    }

    window.zIndex = self.nextZIndex++;

    window.state = window.state == BTWindowStateMinimized
        ? BTWindowStateNormal
        : window.state;

    window.visible = YES;

    [self notifyChange];
}

- (void)switchToWorkspace:(NSInteger)workspace {
    if (workspace < 1 || workspace > 4) {
        return;
    }

    if (workspace == self.currentWorkspace) {
        return;
    }

    self.currentWorkspace = workspace;

    for (BTWindow *window in self.mutableWindows) {
        window.visible =
            (window.workspace == workspace &&
             window.state != BTWindowStateMinimized);
    }

    [self notifyChange];
}

- (NSArray<BTWindow *> *)windowsForWorkspace:(NSInteger)workspace {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:
        ^BOOL(BTWindow *window, NSDictionary *bindings) {
            return window.workspace == workspace;
        }];

    NSArray<BTWindow *> *result =
        [self.mutableWindows filteredArrayUsingPredicate:predicate];

    return [result sortedArrayUsingComparator:
        ^NSComparisonResult(BTWindow *a, BTWindow *b) {

            if (a.zIndex < b.zIndex) {
                return NSOrderedAscending;
            }

            if (a.zIndex > b.zIndex) {
                return NSOrderedDescending;
            }

            return NSOrderedSame;
        }];
}

@end
