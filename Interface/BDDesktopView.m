
#import "BDDesktopView.h"

@interface BDDesktopView ()

@property (nonatomic, strong) CAGradientLayer *backgroundGradient;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *dock;
@property (nonatomic, strong) NSMutableArray<UIButton *> *desktopButtons;

@end

@implementation BDDesktopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = UIColor.blackColor;

        [self setupBackground];
        [self setupTopBar];
        [self setupDesktop];
        [self setupDock];
    }

    return self;
}

- (void)setupBackground {
    self.backgroundGradient = [CAGradientLayer layer];

    self.backgroundGradient.colors = @[
        (__bridge id)[UIColor colorWithRed:0.08
                                    green:0.12
                                     blue:0.23
                                    alpha:1].CGColor,

        (__bridge id)[UIColor colorWithRed:0.18
                                    green:0.24
                                     blue:0.38
                                    alpha:1].CGColor
    ];

    self.backgroundGradient.startPoint =
        CGPointMake(0, 0);

    self.backgroundGradient.endPoint =
        CGPointMake(1, 1);

    [self.layer insertSublayer:self.backgroundGradient
                       atIndex:0];
}

- (void)setupTopBar {
    self.topBar = [[UIView alloc] init];

    self.topBar.backgroundColor =
        [[UIColor blackColor] colorWithAlphaComponent:0.35];

    [self addSubview:self.topBar];

    UILabel *brand = [[UILabel alloc] init];

    brand.text = @"BACUS";
    brand.font = [UIFont boldSystemFontOfSize:16];
    brand.textColor = UIColor.whiteColor;

    [self.topBar addSubview:brand];

    self.titleLabel = brand;

    self.statusLabel = [[UILabel alloc] init];

    self.statusLabel.text = @"Desktop 0.1.0";
    self.statusLabel.textColor =
        [UIColor colorWithWhite:1 alpha:0.75];

    self.statusLabel.font =
        [UIFont systemFontOfSize:12];

    self.statusLabel.textAlignment =
        NSTextAlignmentRight;

    [self.topBar addSubview:self.statusLabel];
}

- (void)setupDesktop {
    self.desktopButtons = [NSMutableArray array];

    NSArray *names = @[
        @"Archivos",
        @"Ajustes",
        @"Clima G",
        @"Aplicaciones"
    ];

    NSArray *symbols = @[
        @"folder.fill",
        @"gearshape.fill",
        @"cloud.sun.fill",
        @"square.grid.2x2.fill"
    ];

    for (NSInteger i = 0; i < names.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

        UIImage *image =
            [UIImage systemImageNamed:symbols[i]];

        [button setImage:image
                forState:UIControlStateNormal];

        button.tintColor = UIColor.whiteColor;
        button.backgroundColor =
            [[UIColor whiteColor] colorWithAlphaComponent:0.12];

        button.layer.cornerRadius = 16;

        button.tag = i;

        [button addTarget:self
                   action:@selector(desktopButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];

        UILabel *label = [[UILabel alloc] init];

        label.text = names[i];
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;

        [self addSubview:label];

        [self.desktopButtons addObject:button];
    }
}

- (void)setupDock {
    self.dock = [[UIView alloc] init];

    self.dock.backgroundColor =
        [[UIColor blackColor] colorWithAlphaComponent:0.4];

    self.dock.layer.cornerRadius = 22;

    [self addSubview:self.dock];

    NSArray *symbols = @[
        @"house.fill",
        @"square.grid.2x2.fill",
        @"gearshape.fill"
    ];

    for (NSInteger i = 0; i < symbols.count; i++) {
        UIButton *button =
            [UIButton buttonWithType:UIButtonTypeSystem];

        [button setImage:
            [UIImage systemImageNamed:symbols[i]]
                forState:UIControlStateNormal];

        button.tintColor = UIColor.whiteColor;

        [self.dock addSubview:button];
    }
}

- (void)desktopButtonPressed:(UIButton *)sender {
    NSArray *names = @[
        @"Archivos",
        @"Ajustes",
        @"Clima G",
        @"Aplicaciones"
    ];

    if (sender.tag >= names.count) {
        return;
    }

    self.statusLabel.text =
        [NSString stringWithFormat:
         @"%@ · Próximamente", names[sender.tag]];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect bounds = self.bounds;

    self.backgroundGradient.frame = bounds;

    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);

    self.topBar.frame =
        CGRectMake(0, 0, width, 48);

    self.titleLabel.frame =
        CGRectMake(18, 0, 110, 48);

    self.statusLabel.frame =
        CGRectMake(width - 170, 0, 155, 48);

    CGFloat buttonWidth = 64;
    CGFloat spacing = 24;

    CGFloat startX = 28;
    CGFloat startY = 100;

    for (NSInteger i = 0;
         i < self.desktopButtons.count;
         i++) {

        UIButton *button = self.desktopButtons[i];

        CGFloat x = startX;
        CGFloat y = startY + i * (buttonWidth + spacing);

        button.frame =
            CGRectMake(x, y, buttonWidth, buttonWidth);

        UILabel *label = nil;

        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UILabel class]] &&
                view != self.titleLabel &&
                view != self.statusLabel) {

                UILabel *candidate = (UILabel *)view;

                if ([candidate.text isEqualToString:
                     @[@"Archivos", @"Ajustes",
                       @"Clima G", @"Aplicaciones"][i]]) {
                    label = candidate;
                    break;
                }
            }
        }

        label.frame =
            CGRectMake(x - 12, y + buttonWidth,
                       buttonWidth + 24, 22);
    }

    CGFloat dockWidth = 190;
    CGFloat dockHeight = 58;

    self.dock.frame =
        CGRectMake((width - dockWidth) / 2,
                   height - dockHeight - 22,
                   dockWidth, dockHeight);

    CGFloat itemWidth = dockWidth / 3;

    for (NSInteger i = 0;
         i < self.dock.subviews.count;
         i++) {

        UIView *item = self.dock.subviews[i];

        item.frame = CGRectMake(
            i * itemWidth,
            0,
            itemWidth,
            dockHeight
        );
    }
}

@end
