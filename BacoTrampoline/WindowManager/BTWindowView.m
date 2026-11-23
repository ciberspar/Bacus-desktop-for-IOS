
#import "BTWindowView.h"
#import "BTWindowManager.h"

@interface BTWindowView ()

@property (nonatomic, strong, readwrite) BTWindow *managedWindow;
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *minimizeButton;
@property (nonatomic, strong) UIButton *maximizeButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) CGRect dragStartFrame;

@end

@implementation BTWindowView

- (instancetype)initWithWindow:(BTWindow *)window {

    self = [super initWithFrame:window.frame];

    if (self) {
        _managedWindow = window;

        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor =
            [UIColor colorWithWhite:0.55 alpha:1.0].CGColor;

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.20;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);

        [self buildInterface];

        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(updateFromModel)
                   name:BTWindowManagerDidChangeNotification
                 object:[BTWindowManager sharedManager]];

        [self updateFromModel];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildInterface {

    self.titleBar = [[UIView alloc]
        initWithFrame:CGRectZero];

    self.titleBar.backgroundColor =
        [UIColor colorWithRed:0.20
                        green:0.38
                         blue:0.68
                        alpha:1.0];

    self.titleBar.layer.cornerRadius = 7.0;
    self.titleBar.clipsToBounds = YES;

    [self addSubview:self.titleBar];

    self.titleLabel = [[UILabel alloc]
        initWithFrame:CGRectZero];

    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font =
        [UIFont boldSystemFontOfSize:13.0];

    [self.titleBar addSubview:self.titleLabel];

    self.minimizeButton =
        [self createButtonWithTitle:@"−"
                              color:[UIColor colorWithWhite:0.85 alpha:1.0]
                             action:@selector(minimizePressed)];

    self.maximizeButton =
        [self createButtonWithTitle:@"□"
                              color:[UIColor colorWithWhite:0.85 alpha:1.0]
                             action:@selector(maximizePressed)];

    self.closeButton =
        [self createButtonWithTitle:@"×"
                              color:[UIColor colorWithRed:0.85
                                                    green:0.25
                                                     blue:0.22
                                                    alpha:1.0]
                             action:@selector(closePressed)];

    [self.titleBar addSubview:self.minimizeButton];
    [self.titleBar addSubview:self.maximizeButton];
    [self.titleBar addSubview:self.closeButton];

    self.contentView = [[UIView alloc]
        initWithFrame:CGRectZero];

    self.contentView.backgroundColor =
        [UIColor colorWithWhite:0.97 alpha:1.0];

    [self addSubview:self.contentView];

    UIPanGestureRecognizer *pan =
        [[UIPanGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(handleDrag:)];

    pan.cancelsTouchesInView = NO;

    [self.titleBar addGestureRecognizer:pan];
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                              color:(UIColor *)color
                             action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];

    button.backgroundColor = color;
    button.titleLabel.font =
        [UIFont boldSystemFontOfSize:17.0];

    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)layoutSubviews {

    [super layoutSubviews];

    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGFloat titleHeight = 34.0;
    CGFloat buttonWidth = 30.0;

    self.titleBar.frame =
        CGRectMake(0, 0, width, titleHeight);

    self.closeButton.frame =
        CGRectMake(width - buttonWidth, 0,
                   buttonWidth, titleHeight);

    self.maximizeButton.frame =
        CGRectMake(width - buttonWidth * 2, 0,
                   buttonWidth, titleHeight);

    self.minimizeButton.frame =
        CGRectMake(width - buttonWidth * 3, 0,
                   buttonWidth, titleHeight);

    self.titleLabel.frame =
        CGRectMake(9, 0, width - 105, titleHeight);

    self.contentView.frame =
        CGRectMake(0, titleHeight,
                   width, MAX(0, height - titleHeight));
}

- (void)updateFromModel {

    BTWindowManager *manager =
        [BTWindowManager sharedManager];

    if (![manager.windows containsObject:self.managedWindow]) {
        [self removeFromSuperview];
        return;
    }

    self.hidden = !self.managedWindow.isVisible;

    self.frame = self.managedWindow.frame;
    self.titleLabel.text = self.managedWindow.title;

    [self setNeedsLayout];
}

- (void)handleDrag:(UIPanGestureRecognizer *)gesture {

    BTWindowManager *manager =
        [BTWindowManager sharedManager];

    if (gesture.state == UIGestureRecognizerStateBegan) {

        [manager bringWindowToFront:self.managedWindow];

        self.dragStartFrame = self.frame;

    } else if (gesture.state == UIGestureRecognizerStateChanged) {

        if (self.managedWindow.state ==
            BTWindowStateMaximized) {
            return;
        }

        CGPoint translation =
            [gesture translationInView:self.superview];

        CGRect newFrame = self.dragStartFrame;

        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;

        [manager moveWindow:self.managedWindow
                    toFrame:newFrame];
    }
}

- (void)minimizePressed {

    [[BTWindowManager sharedManager]
        minimizeWindow:self.managedWindow];
}

- (void)maximizePressed {

    if (!self.superview) {
        return;
    }

    CGRect bounds = self.superview.bounds;

    [[BTWindowManager sharedManager]
        toggleMaximizeWindow:self.managedWindow
                withinBounds:bounds];
}

- (void)closePressed {

    [[BTWindowManager sharedManager]
        closeWindow:self.managedWindow];
}

@end
