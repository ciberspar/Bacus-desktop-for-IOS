
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTWindowState) {
    BTWindowStateNormal = 0,
    BTWindowStateMinimized,
    BTWindowStateMaximized
};

@interface BTWindow : NSObject

@property (nonatomic, copy) NSString *windowID;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger workspace;
@property (nonatomic, assign) NSInteger zIndex;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect restoreFrame;

@property (nonatomic, assign) BTWindowState state;

@property (nonatomic, assign, getter=isVisible) BOOL visible;

- (instancetype)initWithTitle:(NSString *)title
                        frame:(CGRect)frame
                    workspace:(NSInteger)workspace;

@end
