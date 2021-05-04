//
//  ViewController.m
//  WCSettingUI
//
//  Created by 排骨 on 2021/3/1.
//  Copyright © 2021 排骨. All rights reserved.
//
#import "WCHLViewController.h"


@interface WCHLViewController ()
@property (nonatomic, strong) UIView *naviBGView;
@property (nonatomic, strong) MMTableViewInfo *m_tableViewInfo;

@end

@implementation WCHLViewController


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
    [self setTitle:@"WeChatHookLite"];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)];

    
    MMTableView *tableView = [self.m_tableViewInfo getTableView];

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 195)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    MMUILabel *footerLabel = [[objc_getClass("MMUILabel") alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 195)];

    [footerLabel setText:@"All Rights Reserved By 糖醋丶炒排骨"];
    [footerLabel setTextAlignment:NSTextAlignmentCenter];
    [footerLabel setTextStyle:10];
    [footerLabel setNumberOfLines:0];

    footerLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [footerView addSubview:footerLabel];


    [self reloadTableData];
    [tableView setTableHeaderView:headView];
    [tableView setTableFooterView:footerView];

    [self.m_tableViewInfo addTableViewToSuperView:self.view];
}

- (void)reloadTableData
{
    [self.m_tableViewInfo clearAllSection];
    
    WCTableViewSectionManager *sectionInfo1 = [objc_getClass("WCTableViewSectionManager") sectionInfoFooter:@"加强版反越狱检测、防封(针对小号越狱环境，对抢红包改步数等没有作用，防封对大号没有太大意义，大号基本不会被封)。这里的反越狱检测并非只是可以用面容指纹支付那种简单的做法。此项建议保持开启"];
    WCTableViewSectionManager *sectionInfo2 = [objc_getClass("WCTableViewSectionManager") sectionInfoFooter:@"选择启用所需的功能"];
    WCTableViewSectionManager *sectionInfo3 = [objc_getClass("WCTableViewSectionManager") sectionInfoDefaut];
    WCTableViewSectionManager *sectionInfo4 = [objc_getClass("WCTableViewSectionManager") sectionInfoDefaut];

    [sectionInfo1 addCell:[self createJBBypassCell]];
    [sectionInfo2 addCell:[self createFunctionSwitchCell]];
    [sectionInfo3 addCell:[self createAboutMeCell]];
    [sectionInfo4 addCell:[self createExitCell]];

    [self.m_tableViewInfo addSection:sectionInfo1];
    [self.m_tableViewInfo addSection:sectionInfo2];
    [self.m_tableViewInfo addSection:sectionInfo3];
    [self.m_tableViewInfo addSection:sectionInfo4];

    MMTableView *tableView = [self.m_tableViewInfo getTableView];
    [tableView reloadData];
}

//创建反越狱cell
- (WCTableViewCellManager *)createJBBypassCell 
{
    return [objc_getClass("WCTableViewCellManager") switchCellForSel:@selector(wc_jbbypass:) target:self title:@"反越狱检测/防封" on:[WCHLOptions sharedConfig].jbbypass];
}

- (void)wc_jbbypass:(UISwitch *)switchView
{
    [[WCHLOptions sharedConfig] setJbbypass:switchView.isOn];
    [self reloadTableData];
}

//创建功能模块cell
- (WCTableViewCellManager *)createFunctionSwitchCell 
{
    return [objc_getClass("WCTableViewCellManager") normalCellForSel:@selector(newSettingVC) target:self title:@"选择所需的功能"];
}

- (void)newSettingVC
{
    UIViewController *settingViewController = [[WCHLSettingViewController alloc] init];
	[settingViewController setHidesBottomBarWhenPushed:YES];

	[self.navigationController PushViewController:settingViewController animated:YES];
}

//创建关于作者cell
- (WCTableViewCellManager *)createAboutMeCell 
{
    return [objc_getClass("WCTableViewCellManager") normalCellForSel:@selector(aboutMeVC) target:self title:@"关于此插件"];
}

- (void)aboutMeVC
{
    UIViewController *settingViewController = [[WCHLAboutMeViewController alloc] init];
	[settingViewController setHidesBottomBarWhenPushed:YES];

	[self.navigationController PushViewController:settingViewController animated:YES];
}


//创建捐赠cell
- (WCTableViewCellManager *)createExitCell 
{
    return [objc_getClass("WCTableViewCellManager") centerCellForSel:@selector(exitApp) target:self title:@"退出微信应用"];
}


- (void)exitApp 
{
    //来 加个动画，给用户一个友好的退出界面
    [UIView beginAnimations:@"exitApp" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}


- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApp"] == 0) 
        exit(0);
}

@end
