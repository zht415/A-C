//
//  AnimationsListViewController.m
//  Facebook-POP-Animation
//
//  Created by YouXianMing on 15/11/16.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "Header.h"
#import "AnimationsListViewController.h"
#import "UIView+AnimationsListViewController.h"
#import "UIView+SetRect.h"
#import "UIView+GlowView.h"
#import "UITableView+CellClass.h"
#import "ListItemCell.h"
#import "BackgroundLineView.h"
#import "DefaultNotificationCenter.h"
#import "Item.h"
#import "GCD.h"
#import "IndexRange.h"
#import "ControllerPushAnimator.h"
#import "ControllerPopAnimator.h"
#import "UIFont+Fonts.h"
#import "NotificationCenterString.h"
#import "NSString+HexColors.h"

#import "ButtonPressViewController.h"
#import "PopStrokeController.h"
//#import "CAShapeLayerPathController.h"
//#import "TransformFadeViewController.h"
//#import "CAGradientViewController.h"
//#import "PopNumberController.h"
//#import "CircleAnimationViewController.h"
//#import "ScrollImageViewController.h"
//#import "ScrollBlurImageViewController.h"
//#import "TableViewTapAnimationController.h"
//#import "POPSpringParameterController.h"
//#import "HeaderViewTapAnimationController.h"
//#import "CountDownTimerController.h"
//#import "ClockViewController.h"
//#import "DrawWaveViewController.h"
//#import "LabelScaleViewController.h"
//#import "ShimmerController.h"
//#import "EmitterSnowController.h"
//#import "ScratchImageViewController.h"
//#import "LiveImageViewController.h"
//#import "SDWebImageController.h"
//#import "AlertViewController.h"
//#import "WaterfallLayoutController.h"
//#import "MixedColorProgressViewController.h"
//#import "PageFlipEffectController.h"
//#import "CATransform3DM34Controller.h"
//#import "PressAnimationButtonController.h"
//#import "BezierPathViewController.h"
//#import "MusicBarAnimationController.h"
//#import "ColorProgressViewController.h"
//#import "SpringEffectController.h"
//#import "CASpringAnimationController.h"
//#import "AdditiveAnimationController.h"
//#import "TableViewLoadDataController.h"
//#import "MotionEffectViewController.h"
//#import "GifPictureController.h"
//#import "SCViewShakerController.h"
//#import "ScrollViewAnimationController.h"
//#import "TapCellAnimationController.h"
//#import "TextKitLoadImageController.h"
//#import "ReplicatorLineViewController.h"
//#import "DrawMarqueeViewController.h"
//#import "LazyFadeInViewController.h"
//#import "OffsetCellViewController.h"
//#import "SystemFontInfoController.h"
//#import "iCarouselViewController.h"
//#import "GridFlowLayoutViewController.h"
//#import "InfiniteLoopViewController.h"
//#import "BaseControlViewController.h"
//#import "SpringScaleViewController.h"
//#import "TapPathDrawViewController.h"
//#import "QRCodeViewController.h"
//#import "MaskShapeViewController.h"
//#import "WaterWaveViewController.h"
//#import "IrregularGridViewController.h"
//#import "MixCellsViewController.h"
//#import "ScrollCarouselViewController.h"

@interface AnimationsListViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, DefaultNotificationCenterDelegate>

@property (nonatomic, strong) UISegmentedControl        *segControl;
@property (nonatomic)         NSInteger                 selectedIndex;
@property (nonatomic, strong) DefaultNotificationCenter *notificationCenter;
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic)         BOOL                       tableViewLoadData;

@property (nonatomic, strong) NSMutableArray  <CellDataAdapter *> *items;

@end

@implementation AnimationsListViewController

- (void)setup {

    [super setup];
    
    [self rootViewControllerSetup];
    
    [self configNotificationCenter];
    
    [self configureDataSource];
    
    [self configureTableView];
    
    [self configureTitleView];
    
     [self creatSegmentControl];
}

#pragma mark - RootViewController setup.

- (void)rootViewControllerSetup {
    
    // [IMPORTANT] Enable the Push transitioning.
    self.navigationController.delegate = self;
    
    // [IMPORTANT] Set the RootViewController's push delegate.
    [self useInteractivePopGestureRecognizer];
}

#pragma mark - Push or Pop event.

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        
        return [ControllerPushAnimator new];
        
    } else if (operation == UINavigationControllerOperationPop) {
        
        return [ControllerPopAnimator new];
        
    } else {
        
        return nil;
    }
}

#pragma mark - configNotificationCenter

- (void)configNotificationCenter {

    self.notificationCenter          = [DefaultNotificationCenter new];
    self.notificationCenter.delegate = self;
    [self.notificationCenter addNotificationName:noti_showHomePageTableView];
}

#pragma mark - DefaultNotificationCenterDelegate

- (void)defaultNotificationCenter:(DefaultNotificationCenter *)notification name:(NSString *)name object:(id)object {
 
    if ([name isEqualToString:noti_showHomePageTableView]) {
        
        [GCDQueue executeInMainQueue:^{
                        
            // Load data.
            self.tableViewLoadData = YES;
            [self.tableView insertRowsAtIndexPaths:MakeIndexRanges(@[MakeIndexRange(0, self.items.count, 0)]) withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}



#pragma mark - Config SegmentControl


- (void)creatSegmentControl{

    self.segControl = [[UISegmentedControl alloc] initWithItems:@[@"动画动效",@"金融图表"]];
    [self.titleView addSubview:self.segControl];
    
    self.segControl.frame                = CGRectMake(0, 0, 151*ScreenWidthRate, 30*ScreenHeightRate);
    self.segControl.center               = CGPointMake(self.titleView.centerX, self.titleView.centerY+10);
    self.segControl.tintColor            = [UIColor yellowColor];
    self.segControl.selectedSegmentIndex = 0;
    self.selectedIndex                   = 0;
    
    [self.segControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.5]} forState:UIControlStateNormal];
    [self.segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[@"1E3C72" hexColor]} forState:UIControlStateSelected];


}

#pragma mark - Config TitleView.

- (void)configureTitleView {
    
    BackgroundLineView *lineView = [BackgroundLineView backgroundLineViewWithFrame:CGRectMake(0, 0, self.width, 64)
                                                                         lineWidth:4 lineGap:4
                                                                         lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.015]
                                                                            rotate:M_PI_4];
    [self.titleView addSubview:lineView];
    
    // Title label.
    UILabel *headlinelabel          = [UIView animationsListViewControllerNormalHeadLabel];
    UILabel *animationHeadLineLabel = [UIView animationsListViewControllerHeadLabel];
    
    // Title view.
    UIView *titleView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    headlinelabel.center          = titleView.middlePoint;
    animationHeadLineLabel.center = titleView.middlePoint;
    [titleView addSubview:headlinelabel];
    [titleView addSubview:animationHeadLineLabel];
    [self.titleView addSubview:titleView];
    
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, self.width, 0.5f)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    [titleView addSubview:line];
    
    // Start glow.
    animationHeadLineLabel.glowRadius            = @(2.f);
    animationHeadLineLabel.glowOpacity           = @(1.f);
    animationHeadLineLabel.glowColor             = [[UIColor colorWithRed:0.203  green:0.598  blue:0.859 alpha:1] colorWithAlphaComponent:0.95f];
    
    animationHeadLineLabel.glowDuration          = @(1.f);
    animationHeadLineLabel.hideDuration          = @(3.f);
    animationHeadLineLabel.glowAnimationDuration = @(2.f);
    
    [animationHeadLineLabel createGlowLayer];
    [animationHeadLineLabel insertGlowLayer];
    
    [GCDQueue executeInMainQueue:^{
        
        [animationHeadLineLabel startGlowLoop];
        
    } afterDelaySecs:2.f];
}

#pragma mark - Config DataSource.

- (void)configureDataSource {
    
    NSArray *array = @[[Item itemWithName:@"POP-按钮动画" object:[ButtonPressViewController class]],
                       [Item itemWithName:@"POP-Stroke动画" object:[PopStrokeController class]]];
    
    self.items = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
    
        Item *item = array[i];
        item.index = i + 1;
        [item createAttributedString];

        [self.items addObject:[ListItemCell dataAdapterWithCellReuseIdentifier:nil data:item cellHeight:0 type:0]];
    }
}

#pragma mark - TableView Related.

- (void)configureTableView {
    
    self.tableView                = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.tableView.delegate       = self;
    self.tableView.dataSource     = self;
    self.tableView.rowHeight      = 50.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerCellsClass:@[cellClass(@"ListItemCell", nil)]];
    [self.contentView addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableViewLoadData ? self.items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView dequeueAndLoadContentReusableCellFromAdapter:_items[indexPath.row] indexPath:indexPath controller:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [(CustomCell *)[tableView cellForRowAtIndexPath:indexPath] selectedEvent];    
}


#pragma mark - 分割器响应事件
- (void)segmentAction:(UISegmentedControl*)sender{
    
     NSInteger index = sender.selectedSegmentIndex;
    
    if (self.selectedIndex != index) {
        
        self.selectedIndex = index;
        
        self.segControl.selectedSegmentIndex = index;
      
    }

    


}

#pragma mark - Overwrite system methods.

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.enableInteractivePopGestureRecognizer = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
//    self.enableInteractivePopGestureRecognizer = YES;
}

@end
