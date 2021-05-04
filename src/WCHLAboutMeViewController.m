//
//  ViewController.m
//  WCSettingUI
//
//  Created by 排骨 on 2021/3/1.
//  Copyright © 2021 排骨. All rights reserved.
//
#import "WCHLAboutMeViewController.h"

@interface WCHLAboutMeViewController ()

@property (nonatomic, strong) MMTableViewInfo *m_tableViewInfo;

@end

@implementation WCHLAboutMeViewController


- (MMTableViewInfo *)m_tableViewInfo 
{
    if (!_m_tableViewInfo) 
    {
        _m_tableViewInfo = [[objc_getClass("MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    return _m_tableViewInfo;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self setTitle:@"关于此插件"];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)];
    
    MMTableView *tableView = [self.m_tableViewInfo getTableView];

    [tableView setTableHeaderView:headView];

    [self reloadTableData];
    [self.m_tableViewInfo addTableViewToSuperView:self.view];
}

- (void)reloadTableData
{
    [self.m_tableViewInfo clearAllSection];
    
    WCTableViewSectionManager *sectionInfo1 = [objc_getClass("WCTableViewSectionManager") sectionInfoDefaut];
    
    [sectionInfo1 addCell:[self createDonateCell]];
    [sectionInfo1 addCell:[self createMyRepoCell]];
    [sectionInfo1 addCell:[self createMyWeiboCell]];

    [self.m_tableViewInfo addSection:sectionInfo1];

    MMTableView *tableView = [self.m_tableViewInfo getTableView];
    [tableView reloadData];
}

//创建捐赠cell
- (WCTableViewCellManager *)createDonateCell 
{
    return [objc_getClass("WCTableViewCellManager") centerCellForSel:@selector(openDonate) target:self title:@"请我吃碗泡面" detail:@"如果你想支持这个插件的开发，你可以"];
}

- (void)openDonate
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"https://qr.alipay.com/fkx11847cc72d5vzsopdv56"]
        options:@{}
        completionHandler:nil];
}

//创建打开软件源cell
- (WCTableViewCellManager *)createMyRepoCell 
{
    return [objc_getClass("WCTableViewCellManager") centerCellForSel:@selector(openMyRepo) target:self title:@"插件的源地址"];
}

- (void)openMyRepo
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"http://apt.paigu.site"]
        options:@{}
        completionHandler:nil];
}

//创建打开微博cell
- (WCTableViewCellManager *)createMyWeiboCell 
{
    return [objc_getClass("WCTableViewCellManager") centerCellForSel:@selector(openMyWeibo) target:self title:@"关注我的微博" detail:@"如果你有任何的问题或建议，烦请留言"];
}

- (void)openMyWeibo
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"https://weibo.com/u/7321330374/"]
        options:@{}
        completionHandler:nil];
}


@end
