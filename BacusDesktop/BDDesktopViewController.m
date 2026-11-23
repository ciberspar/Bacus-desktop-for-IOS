
#import "BDDesktopViewController.h"
#import "../BacoTrampoline/BTDesktopEngine.h"

@interface BDDesktopViewController ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *dock;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *workspaceLabel;
@property (nonatomic, strong) UIButton *themeButton;
@property (nonatomic, strong) UIButton *workspaceButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *desktopButtons;

@end

@implementation BDDesktopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.desktopButtons = [NSMutableArray array];

    [self createTopBar];
    [self createDesktop];
    [self createDock];
    [self applyTheme];
}

- (void)createTopBar {
    self.topBar = [[UIView alloc] init];
    [self.view addSubview:self.topBar];

    self.brandLabel = [[UILabel alloc] init];
    self.brandLabel.text = @"BACUS DESKTOP";
    self.brandLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.topBar addSubview:self.brandLabel];

    self.workspaceLabel = [[UILabel alloc] init];
    self.workspaceLabel.font = [UIFont systemFontOfSize:12];
    [self.topBar addSubview:self.workspaceLabel];

    self.themeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.themeButton setTitle:@"Cambiar tema" forState:UIControlStateNormal];
    [self.themeButton addTarget:self
                         action:@selector(changeTheme)
               forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.themeButton];

    self.workspaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.workspaceButton setTitle:@"Escritorio 1" forState:UIControlStateNormal];
    [self.workspaceButton addTarget:self
                             action:@selector(changeWorkspace)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.workspaceButton];
}

- (void)createDesktop {
    NSArray *names = @[
        @"Archivos",
        @"Ajustes",
        @"Aplicaciones",
        @"Clima G"
    ];

    for (NSString *name in names) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

        [button setTitle:name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.titleLabel.numberOfLines = 2;
        button.layer.cornerRadius = 10;
        button.tag = self.desktopButtons.count;

        [button addTarget:self
                   action:@selector(openDesktopItem:)
         forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:button];
        [self.desktopButtons addObject:button];
    }
}

- (void)createDock {
    self.dock = [[UIView alloc] init];
    self.dock.layer.cornerRadius = 17;
    [self.view addSubview:self.dock];

    NSArray *names = @[@"Inicio", @"Buscar", @"Ajustes"];

    for (NSInteger i = 0; i < names.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

        [button setTitle:names[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        button.tag = i;

        [button addTarget:self
                   action:@selector(dockPressed:)
         forControlEvents:UIControlEventTouchUpInside];

        [self.dock addSubview:button];
    }
}

- (void)changeTheme {
    [[BTDesktopEngine sharedEngine] nextTheme];
    [self applyTheme];
}

- (void)changeWorkspace {
    [[BTDesktopEngine sharedEngine] nextWorkspace];
    [self applyTheme];
}

- (void)openDesktopItem:(UIButton *)sender {
    NSArray *names = @[
        @"Archivos",
        @"Ajustes",
        @"Aplicaciones",
        @"Clima G"
    ];

    if (sender.tag < names.count) {
        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:names[sender.tag]
                                                message:@"Este módulo se desarrollará en una próxima versión."
                                         preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
            [UIAlertAction actionWithTitle:@"Aceptar"
                                     style:UIAlertActionStyleDefault
                                   handler:nil]];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)dockPressed:(UIButton *)sender {
    if (sender.tag == 0) {
        [[BTDesktopEngine sharedEngine] setTheme:BTThemeStyleClassic2000];
        [self applyTheme];
    } else if (sender.tag == 1) {
        [self changeWorkspace];
    } else if (sender.tag == 2) {
        [[BTDesktopEngine sharedEngine] setTheme:BTThemeStyleBacusDark];
        [self applyTheme];
    }
}

- (void)applyTheme {
    BTTheme *theme = [BTDesktopEngine sharedEngine].currentTheme;

    self.view.backgroundColor = theme.backgroundColor;
    self.topBar.backgroundColor = theme.panelColor;
    self.dock.backgroundColor = theme.panelColor;

    self.brandLabel.textColor = theme.textColor;
    self.workspaceLabel.textColor = theme.textColor;

    [self.themeButton setTitleColor:theme.accentColor
                           forState:UIControlStateNormal];

    [self.workspaceButton setTitleColor:theme.textColor
                               forState:UIControlStateNormal];

    for (UIButton *button in self.desktopButtons) {
        button.backgroundColor = theme.panelColor;
        [button setTitleColor:theme.textColor
                     forState:UIControlStateNormal];
    }

    for (UIButton *button in self.dock.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:theme.textColor
                         forState:UIControlStateNormal];
        }
    }

    self.workspaceLabel.text =
        [NSString stringWithFormat:@"Espacio %ld",
         (long)[BTDesktopEngine sharedEngine].workspace];

    [self.workspaceButton setTitle:
        [NSString stringWithFormat:@"Espacio %ld",
         (long)[BTDesktopEngine sharedEngine].workspace]
                          forState:UIControlStateNormal];

    [self.themeButton setTitle:
        [NSString stringWithFormat:@"Tema: %@", theme.name]
                      forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    self.topBar.frame = CGRectMake(0, 0, width, 65);

    self.brandLabel.frame = CGRectMake(12, 5, 145, 25);
    self.workspaceLabel.frame = CGRectMake(12, 34, 110, 22);

    self.themeButton.frame =
        CGRectMake(width - 150, 5, 140, 26);

    self.workspaceButton.frame =
        CGRectMake(width - 150, 34, 140, 24);

    CGFloat startY = 100;

    for (NSInteger i = 0; i < self.desktopButtons.count; i++) {
        NSInteger column = i % 2;
        NSInteger row = i / 2;

        CGFloat x = 20 + column * ((width - 60) / 2);
        CGFloat y = startY + row * 100;

        self.desktopButtons[i].frame =
            CGRectMake(x, y, (width - 60) / 2, 75);
    }

    CGFloat dockWidth = MIN(width - 40, 300);
    CGFloat dockHeight = 55;

    self.dock.frame = CGRectMake(
        (width - dockWidth) / 2,
        height - dockHeight - 25,
        dockWidth,
        dockHeight
    );

    CGFloat itemWidth = dockWidth / 3;

    for (NSInteger i = 0; i < self.dock.subviews.count; i++) {
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
