
#import "BTTheme.h"

@implementation BTTheme

- (instancetype)initWithStyle:(BTThemeStyle)style {
    self = [super init];

    if (self) {
        _style = style;
    }

    return self;
}

- (NSString *)name {
    switch (self.style) {
        case BTThemeStyleClassic2000:
            return @"Classic 2000";

        case BTThemeStyleBacusGlass:
            return @"Bacus Glass";

        case BTThemeStyleBacusDark:
            return @"Bacus Dark";
    }
}

- (UIColor *)backgroundColor {
    switch (self.style) {
        case BTThemeStyleClassic2000:
            return [UIColor colorWithRed:0.32
                                   green:0.57
                                    blue:0.78
                                   alpha:1];

        case BTThemeStyleBacusGlass:
            return [UIColor colorWithRed:0.12
                                   green:0.19
                                    blue:0.30
                                   alpha:1];

        case BTThemeStyleBacusDark:
            return [UIColor colorWithRed:0.055
                                   green:0.065
                                    blue:0.085
                                   alpha:1];
    }
}

- (UIColor *)panelColor {
    switch (self.style) {
        case BTThemeStyleClassic2000:
            return [UIColor colorWithRed:0.78
                                   green:0.83
                                    blue:0.89
                                   alpha:1];

        case BTThemeStyleBacusGlass:
            return [[UIColor whiteColor] colorWithAlphaComponent:0.20];

        case BTThemeStyleBacusDark:
            return [UIColor colorWithRed:0.13
                                   green:0.15
                                    blue:0.19
                                   alpha:1];
    }
}

- (UIColor *)textColor {
    if (self.style == BTThemeStyleClassic2000) {
        return [UIColor colorWithRed:0.08
                               green:0.12
                                blue:0.20
                               alpha:1];
    }

    return [UIColor whiteColor];
}

- (UIColor *)accentColor {
    switch (self.style) {
        case BTThemeStyleClassic2000:
            return [UIColor colorWithRed:0.12
                                   green:0.35
                                    blue:0.72
                                   alpha:1];

        case BTThemeStyleBacusGlass:
            return [UIColor colorWithRed:0.30
                                   green:0.72
                                    blue:0.95
                                   alpha:1];

        case BTThemeStyleBacusDark:
            return [UIColor colorWithRed:0.35
                                   green:0.65
                                    blue:0.95
                                   alpha:1];
    }
}

@end
