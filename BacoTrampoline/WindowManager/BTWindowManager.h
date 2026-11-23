
#import <UIKit/UIKit.h>
#import "BTWindow.h"

@interface BTWindowView : UIView

@property (nonatomic, strong, readonly) BTWindow *managedWindow;

- (instancetype)initWithWindow:(BTWindow *)window;

- (void)updateFromModel;

@end
