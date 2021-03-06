//
//  LoginButtonController.m
//  A-C
//
//  Created by 刘成利 on 2017/2/16.
//  Copyright © 2017年 刘成利. All rights reserved.
//

#import "LoginButtonController.h"
#import "WaitButton.h"
#import "UIFont+Fonts.h"

@interface LoginButtonController ()

@end

@implementation LoginButtonController

- (void)setup{


    [super setup];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.contentView.layer addSublayer: [self backgroundLayer]];
    self.contentView.backgroundColor = [UIColor orangeColor];
    
    UILabel *label   = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.contentView.frame.size.width, 50)];
    label.textColor     = [UIColor whiteColor];
    label.text          = @"请点击下方按钮看效果！";
    label.font          = [UIFont HeitiSCWithFontSize:17.f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    
    WaitButton *login = [[WaitButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    login.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
    [self.contentView addSubview:login];
    
    __block WaitButton *button = login;
    
    login.finishBlock = ^{
        NSLog(@"跳转了哦");
        button.bounds = CGRectMake(0, 0, 44, 44);
        button.layer.cornerRadius = 22;
        
    
    };


}


-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor purpleColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.65,@1];
    return gradientLayer;
}

@end
