//
//  ViewController.m
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/24.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "ViewController.h"
#import "DCVideoPlayerViewController.h"

@interface ViewController ()
@property (nonatomic, strong) DCVideoPlayerViewController *pv; ///< <#注释#>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DCVideoPlayerItem *item1 = [[DCVideoPlayerItem alloc]initWithTitle:@" Video-MP4-1" URLString:@"http://7xi7xj.com1.z0.glb.clouddn.com/1476085657637.mp4?e=1476107512&token=4GY_U6vPAypr6zc4DkwdpYpNFK2RilZwLo-_sAjQ:FLsurYj-7JYz-ZodhdiyhWUcKq8="];
    DCVideoPlayerItem *item2 = [[DCVideoPlayerItem alloc]initWithTitle:@" Video-MP4-2" URLString:@"http://7xi7xj.com1.z0.glb.clouddn.com/1476084995696.mp4?e=1476106715&token=4GY_U6vPAypr6zc4DkwdpYpNFK2RilZwLo-_sAjQ:ROCEWULIJqdZQ1i5ZWPwJVTtOoA="];
    DCVideoPlayerItem *item3 = [[DCVideoPlayerItem alloc]initWithTitle:@" Video-MP4-3" URLString:@"http://7xi7xj.com1.z0.glb.clouddn.com/1476084995696.mp4?e=1476106715&token=4GY_U6vPAypr6zc4DkwdpYpNFK2RilZwLo-_sAjQ:ROCEWULIJqdZQ1i5ZWPwJVTtOoA="];
    DCVideoPlayerViewController *pv = [[DCVideoPlayerViewController alloc]initWithItems:@[item3,item2,item1]];
    [self addChildViewController:pv];
    _pv = pv;
    _pv.autoPlayWhenReady = YES;
    _pv.hideMenuButton = YES;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    [pv.view setFrame:CGRectMake(0, 64, width, width*9/16)];
    [self.view addSubview:pv.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    if (_pv) {
        return _pv;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
