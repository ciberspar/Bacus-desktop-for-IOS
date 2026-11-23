
#import <Foundation/Foundation.h>
#import "BTTheme.h"

@interface BTDesktopEngine : NSObject

@property (nonatomic, strong, readonly) BTTheme *currentTheme;
@property (nonatomic, assign, readonly) NSInteger workspace;

+ (instancetype)sharedEngine;

- (void)nextTheme;
- (void)setTheme:(BTThemeStyle)style;
- (void)nextWorkspace;

@end
