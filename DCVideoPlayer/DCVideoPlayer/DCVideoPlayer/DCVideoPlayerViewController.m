//
//  DCVideoPlayerViewController.m
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCVideoPlayerViewController.h"


@interface DCVideoPlayerViewController ()<DCVideoPlayerDelegate>
@property (nonatomic, strong) DCVideoPlayer *player;
@property (nonatomic, assign) BOOL isHiddenStatusBar;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end

@implementation DCVideoPlayerViewController

- (void)loadView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _player = [[DCVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, width, width* 9/16)];
    self.view = _player.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player.delegate = self;
    _player.view.hideMenuButton = _hideMenuButton;
    _player.view.hidePreButton = _hidePreButton;
    _player.view.hideNextButton = _hideNextButton;
    _player.autoPlayWhenReady = _autoPlayWhenReady;
    [_player setItems:_items];
}


#pragma mark - initinal

- (instancetype)initWithURLString:(NSArray *)urls
{
    self = [super init];
    if (self) {
        if (urls.count > 0 ) {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
            [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[NSString class]]) {
                    DCVideoPlayerItem *item = [[DCVideoPlayerItem alloc]initWithTitle:@"" URLString:obj];
                    [arr addObject:item];
                }else if([obj isKindOfClass:[NSURL class]]) {
                    DCVideoPlayerItem *item = [[DCVideoPlayerItem alloc]initWithTitle:@"" URLString:[(NSURL *)obj absoluteString]];
                    [arr addObject:item];
                }
            }];
            _items = [arr copy];
        }
    }
    return self;
}

- (instancetype)initWithItems:(NSArray<DCVideoPlayerItem *> *)items
{
    self = [super init];
    if (self) {
        _items = [items copy];
    }
    return self;
}


#pragma mark - DCVideoPlayerDelegate

- (void)dismissButtonTaped
{
    
}

- (void)player:(DCVideoPlayer *)videoPlayer screenRotation:(UIInterfaceOrientation)orientation
{
    _orientation = orientation;
    _isHiddenStatusBar = orientation == UIInterfaceOrientationLandscapeRight;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return _isHiddenStatusBar;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return _orientation;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
