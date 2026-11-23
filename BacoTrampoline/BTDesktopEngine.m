
#import "BTDesktopEngine.h"

@interface BTDesktopEngine ()

@property (nonatomic, strong, readwrite) BTTheme *currentTheme;
@property (nonatomic, assign, readwrite) NSInteger workspace;

@end

@implementation BTDesktopEngine

+ (instancetype)sharedEngine {
    static BTDesktopEngine *engine;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        engine = [[BTDesktopEngine alloc] init];
    });

    return engine;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _currentTheme =
            [[BTTheme alloc] initWithStyle:BTThemeStyleClassic2000];

        _workspace = 1;
    }

    return self;
}

- (void)setTheme:(BTThemeStyle)style {
    self.currentTheme = [[BTTheme alloc] initWithStyle:style];
}

- (void)nextTheme {
    NSInteger next = (self.currentTheme.style + 1) % 3;
    [self setTheme:(BTThemeStyle)next];
}

- (void)nextWorkspace {
    self.workspace++;

    if (self.workspace > 4) {
        self.workspace = 1;
    }
}

@end
