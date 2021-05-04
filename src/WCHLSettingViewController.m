//
//  ViewController.m
//  WCSettingUI
//
//  Created by 排骨 on 2020/8/4.
//  Copyright © 2020 排骨. All rights reserved.
//
#import "WCHLSettingViewController.h"

@interface WCHLSettingViewController ()

@property (nonatomic, strong) MMTableViewInfo *m_tableViewInfo;

@end

@implementation WCHLSettingViewController


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
    [self setTitle:@"选择所需的功能"];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    MMTableView *tableView = [self.m_tableViewInfo getTableView];
    //tableView.scrollEnabled = NO;
    //headView.backgroundColor = tableView.backgroundColor;
    //[tableView addSubview:headView];
    //[self scrollViewDidScroll:tableView];
    //[tableView setTableHeaderView:headView];
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 0, 0);
    [self reloadTableData];
    [tableView setTableHeaderView:headView];
    [self.m_tableViewInfo addTableViewToSuperView:self.view];
}

- (void)reloadTableData
{
    [self.m_tableViewInfo clearAllSection];

    WCTableViewSectionManager *sectionInfo1 = [objc_getClass("WCTableViewSectionManager") sectionInfoFooter:@"去除公众号推送的文章内部的贴片广告、底部横幅广告等，但不是对所有文章都有效果；去除朋友圈广告"];

    WCTableViewSectionManager *sectionInfo2 = [objc_getClass("WCTableViewSectionManager") sectionInfoFooter:@"文本消息将以撤回提示的方式拦截保留，非文本消息将被正常保留并提示被撤回。不会拦截自己撤回的消息"];

    WCTableViewSectionManager *sectionInfo3 = [objc_getClass("WCTableViewSectionManager") sectionInfoDefaut];
    
    [sectionInfo1 addCell:[self createNoAdCell]];
    [sectionInfo2 addCell:[self createAntiRevokeCell]];
    [sectionInfo3 addCell:[self createBlurEffectCell]];
    [sectionInfo3 addCell:[self createNoshowStoryCell]];
    [sectionInfo3 addCell:[self createIPadLoginCell]];
    [sectionInfo3 addCell:[self createCallKitCell]];
    [sectionInfo3 addCell:[self createMoreFunctionCell]];

    [self.m_tableViewInfo addSection:sectionInfo1];
    [self.m_tableViewInfo addSection:sectionInfo2];
    [self.m_tableViewInfo addSection:sectionInfo3];

    MMTableView *tableView = [self.m_tableViewInfo getTableView];
    [tableView reloadData];
}


//创建去广告cell
- (WCTableViewCellManager *)createNoAdCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_ads:) target:self title:@"去除微信广告" on:[WCHLOptions sharedConfig].ads];
}

- (void)wc_ads:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setAds:switchView.isOn];
}


//创建防撤回cell
- (WCTableViewCellManager *)createAntiRevokeCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_revoke:) target:self title:@"防止消息撤回" on:[WCHLOptions sharedConfig].revoke];
}

- (void)wc_revoke:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setRevoke:switchView.isOn];
}


//创建高斯模糊cell
- (WCTableViewCellManager *)createBlurEffectCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_blurEffect:) target:self title:@"后台高斯模糊" on:[WCHLOptions sharedConfig].blurEffect];
}
- (void)wc_blurEffect:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setBlurEffect:switchView.isOn];
}


//创建禁用下拉拍摄cell
- (WCTableViewCellManager *)createNoshowStoryCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_showStory:) target:self title:@"禁用下拉拍摄" on:[WCHLOptions sharedConfig].showStory];
}
- (void)wc_showStory:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setShowStory:switchView.isOn];
}


//创建模拟iPad登录cell
- (WCTableViewCellManager *)createIPadLoginCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_iPadLogin:) target:self title:@"模拟iPad登录" on:[WCHLOptions sharedConfig].iPadLogin];
}
- (void)wc_iPadLogin:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setIPadLogin:switchView.isOn];
}

//创建开启callKitcell
- (WCTableViewCellManager *)createCallKitCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_callKitEnable:) target:self title:@"CallKit功能" on:[WCHLOptions sharedConfig].callKitEnable];
}
- (void)wc_callKitEnable:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setCallKitEnable:switchView.isOn];
}

- (WCTableViewCellManager *)createMoreFunctionCell 
{
    return [objc_getClass("WCTableViewCellManager") normalCellForSel:@selector(moreFunc) target:self title:@"更多功能开发中..."];
}

- (void)moreFunc
{
    // UIViewController *settingViewController = [[WCHLSettingViewController alloc] init];
	// [settingViewController setHidesBottomBarWhenPushed:YES];
	// //[self.navigationController setToolbarHidden:YES];
	// [self.navigationController PushViewController:settingViewController animated:YES];
}
@end
