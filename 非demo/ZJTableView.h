//
//  ZJTableView.h
//  test
//
//  Created by qf on 15-3-18.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJTableViewDelegate;
@interface ZJTableView : UITableView
@property (nonatomic, strong) id<ZJTableViewDelegate> delegateRefresh;
- (id)initWithUrl:(NSString *)str isHud:(BOOL)hud parentView:(UIView *)fv;//不带参数，只刷新，是否要菊花窗口
- (void)asiWithUrl:(NSString *)str isHud:(BOOL)hud parentView:(UIView *)fv;
-(void)autoRefreshData:(NSString *)url isHud:(BOOL)hud parentView:(UIView *)fv;
-(void)endFooter;
-(void)endHeader;
@end
@protocol ZJTableViewDelegate <NSObject>
@optional
-(void)drapTopView;
-(void)drapBottomView;
-(void)requestFinishedZj:(NSData *)data;
-(void)requestFailedZj:(NSData *)data;
-(void)autoFinishGetData:(NSMutableArray *)muArr;
@end