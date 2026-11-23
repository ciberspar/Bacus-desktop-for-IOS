
#import <UIKit/UIKit.h>
#import "BTWindow.h"

FOUNDATION_EXPORT NSString * const BTWindowManagerDidChangeNotification;

@interface BTWindowManager : NSObject

@property (nonatomic, assign, readonly) NSInteger currentWorkspace;

@property (nonatomic, copy, readonly) NSArray<BTWindow *> *windows;

+ (instancetype)sharedManager;

// Crear ventanas
- (BTWindow *)openWindowWithTitle:(NSString *)title
                            frame:(CGRect)frame;

// Cerrar ventanas
- (void)closeWindow:(BTWindow *)window;

// Minimizar ventanas
- (void)minimizeWindow:(BTWindow *)window;

// Maximizar y restaurar ventanas
- (void)toggleMaximizeWindow:(BTWindow *)window
                withinBounds:(CGRect)bounds;

// Mover ventanas
- (void)moveWindow:(BTWindow *)window
           toFrame:(CGRect)frame;

// Cambiar el orden visual
- (void)bringWindowToFront:(BTWindow *)window;

// Espacios de trabajo
- (void)switchToWorkspace:(NSInteger)workspace;

- (NSArray<BTWindow *> *)windowsForWorkspace:(NSInteger)workspace;

@end
