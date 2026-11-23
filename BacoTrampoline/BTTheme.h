
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTThemeStyle) {
    BTThemeStyleClassic2000 = 0,
    BTThemeStyleBacusGlass,
    BTThemeStyleBacusDark
};

@interface BTTheme : NSObject

@property (nonatomic, assign) BTThemeStyle style;
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) UIColor *panelColor;
@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, strong, readonly) UIColor *accentColor;

- (instancetype)initWithStyle:(BTThemeStyle)style;
- (NSString *)name;

@end
