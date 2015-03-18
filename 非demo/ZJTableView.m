//
//  ZJTableView.m
//  test
//
//  Created by qf on 15-3-18.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "ZJTableView.h"
#import "MJRefresh.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
@interface ZJTableView()<MJRefreshBaseViewDelegate,ASIHTTPRequestDelegate>
{
    MJRefreshFooterView *footer;
    MJRefreshHeaderView *header;
    NSMutableArray *muArr;
    int pagecount;
    NSString *urlstr;
    UIView *parentview;
    int method;
    BOOL isHud;
    BOOL isAuto;
}
@end

@implementation ZJTableView
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self getHeader];
        [self getFooter];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self getHeader];
        [self getFooter];
    }
    return self;
}
- (id)initWithUrl:(NSString *)str isHud:(BOOL)hud parentView:(UIView *)fv{
    if (self) {
        // Initialization code
        urlstr = str;
        isHud = hud;
        parentview = fv;
        if(hud == YES){
            [self getHud];
        }
        [self getData:1];
        [self getHeader];
        [self getFooter];
    }
    return self;
}
- (void)asiWithUrl:(NSString *)str isHud:(BOOL)hud parentView:(UIView *)fv{
    urlstr = str;
    isHud = hud;
    parentview = fv;
    method = 1;
    if(hud == YES){
        [self getHud];
    }
    [footer removeFromSuperview];
    [self getData:1];
}

-(void)autoRefreshData:(NSString *)url isHud:(BOOL)hud parentView:(UIView *)fv{
    urlstr = url;
    isHud = hud;
    parentview = fv;
    muArr = [[NSMutableArray alloc] init];
    isAuto = YES;
    if(hud == YES){
        [self getHud];
    }
    [self getData:2];
}
-(void)getHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentview animated:YES];
    hud.labelText = @"正在加载...";
    hud.detailsLabelText = @"请稍后";
}
-(void)getData:(int)n{
    if(n == 1){
        NSString *str = urlstr;
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
        request.delegate = self;
        request.tag = 1;
        [request startAsynchronous];
    }
    else if(n == 2){
        NSString *str = [NSString stringWithFormat:urlstr,1];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
        request.delegate = self;
        request.tag = 2;
        [request startAsynchronous];
    }
    else if(n == 3){
        pagecount++;
        NSString *str = [NSString stringWithFormat:urlstr,pagecount];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
        request.delegate = self;
        request.tag = 3;
        [request startAsynchronous];
    }
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    if(isHud == YES)
        [MBProgressHUD hideHUDForView:parentview animated:YES];
    if(request.tag == 1){
        [header endRefreshing];
        NSData *data = request.responseData;
        [self.delegateRefresh requestFinishedZj:data];
    }
    else if(request.tag == 2){
        [muArr removeAllObjects];
        NSData *data = request.responseData;
        [muArr addObject:data];
        [header endRefreshing];
        [self.delegateRefresh autoFinishGetData:muArr];
    }
    else if(request.tag == 3){
        NSData *data = request.responseData;
        [muArr addObject:data];
        [footer endRefreshing];
        [self.delegateRefresh autoFinishGetData:muArr];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    if(request.tag == 1){
        NSData *data = request.responseData;
        [self.delegateRefresh requestFailedZj:data];
    }
    else if(request.tag == 2){

    }
}
-(void)getHeader{
    header = [[MJRefreshHeaderView alloc] initWithScrollView:self];
    header.delegate = self;
}
-(void)getFooter{
    footer = [[MJRefreshFooterView alloc] initWithScrollView:self];
    footer.delegate = self;
}
-(void)endFooter{
    [footer endRefreshing];
}
-(void)endHeader{
    [header endRefreshing];
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(isAuto == YES){
        if(header == refreshView){
            [self getData:2];
        }
        else if (footer == refreshView){
            [self getData:3];
        }
    }
    else{
        if(header == refreshView){
            [self getData:1];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
