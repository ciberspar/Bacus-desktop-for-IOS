
#import "BTWindow.h"

@implementation BTWindow

- (instancetype)initWithTitle:(NSString *)title
                        frame:(CGRect)frame
                    workspace:(NSInteger)workspace {

    self = [super init];

    if (self) {
        _windowID = [[NSUUID UUID] UUIDString];
        _title = [title copy];

        _workspace = MAX(1, MIN(workspace, 4));

        _frame = frame;
        _restoreFrame = frame;

        _zIndex = 0;
        _state = BTWindowStateNormal;
        _visible = YES;
    }

    return self;
}

@end
