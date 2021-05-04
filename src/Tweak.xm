#import "WCHLHeaders.h"
#import "WCHLOptions.h"

#define darkColor [UIColor colorWithRed:(17/255.0f) green:(17/255.0f)blue:(17/255.0f) alpha:1.0f]
#define lightColor [UIColor colorWithRed:(237/255.0f) green:(237/255.0f)blue:(237/255.0f) alpha:1.0f]
#define tweakVersion @"预览版0.0.6"


#pragma mark 插件设置入口

%hook MoreViewController
//插件设置入口

- (void)reloadMoreView
{
	%orig;
	MMTableViewInfo *tableViewMgr = MSHookIvar<id>(self, "m_tableViewMgr");

	WCTableViewSectionManager *sectionInfo = [%c(WCTableViewSectionManager) defaultSection];

	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

	if([self versionCompareFirst:appVersion andVersionSecond:@"7.0.15"] != -1)
	{
		WCTableViewCellManager *settingCell = [%c(WCTableViewCellManager) normalCellForSel:@selector(setting) target:self title:@"WeChatHookLite" rightValue:tweakVersion canRightValueCopy:NO];
		[sectionInfo addCell:settingCell];
	}
		
	else
	{
		WCTableViewCellManager *settingCell = [%c(WCTableViewCellManager) normalCellForSel:@selector(setting) target:self title:@"WeChatHookLite" rightValue:tweakVersion WithDisclosureIndicator:YES];
		[sectionInfo addCell:settingCell];
	}

	[tableViewMgr insertSection:sectionInfo At:4];

	MMTableView *tableView = [tableViewMgr getTableView];
	[tableView reloadData];
}

%new
- (void)setting 
{
	WCHLViewController *settingViewController = [[WCHLViewController alloc] init];
	[settingViewController setHidesBottomBarWhenPushed:YES];
	[((UIViewController *)self).navigationController PushViewController:settingViewController animated:YES];
}

%new
// 比较版本号
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
	for (int i = 0; i < array2.count; i++) 
	{
		NSInteger a = [[array1 objectAtIndex:i] integerValue];
		NSInteger b = [[array2 objectAtIndex:i] integerValue];
		if (a > b) 
			return 1;

		else if (a < b)
			return -1;
	}
	return 0;
}

%new
- (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second
{
	NSArray *versions1 = [first componentsSeparatedByString:@"."];
	NSArray *versions2 = [second componentsSeparatedByString:@"."];
	NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
	NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
	// 确定最大数组
	NSInteger a = (ver1Array.count > ver2Array.count) ? ver1Array.count : ver2Array.count;
	// 补成相同位数数组
	if (ver1Array.count < a) 
		for(NSInteger j = ver1Array.count; j < a; j++)
			[ver1Array addObject:@"0"];
		
	else
		for(NSInteger j = ver2Array.count; j < a; j++)
			[ver2Array addObject:@"0"];
		
		// 比较版本号
	int result = [self compareArray1:ver1Array andArray2:ver2Array];
	static int myres = -1;
	if(result == 1)
		myres = 0; //v1大于v2
	
	else if (result == -1)
		myres = 1;//v1小于v2
	
	else if (result == 0)
		myres = 2;//v1等于v2
	
	return myres;
}


%end

#pragma mark 修复设置项导航栏背景

%hook _UIBarBackground
/*		
	UINavigationBar背景颜色；
	用以解决插件设置项顶部导航栏和状态栏没有背景颜色的问题；
	有bug，整个微信应用的导航栏都出现了背景颜色，导致朋友圈顶部也显示NavigationBar颜色；
	尝试了：
		- (void)viewWillAppear:(BOOL)animated 
		{
			[super viewWillAppear:animated];

			[self.navigationController setNavigationBarHidden:NO animated:animated];
		}
		第一次点击时有效，但当点击过微信自带的设置项以后，插件设置项的导航栏的背景色又为nil了。
	分析微信的viewWillAppear反编译代码，发现就是通过viewWillAppear:中的setNavigationBarHidden方法隐藏导航栏，但是hook无效。
*/
- (void)updateBackground
{
	//可以实时刷新
	%orig;

	[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) 
	{
		if ([obj isMemberOfClass:%c(UIImageView)])
		{   
			if(obj.backgroundColor == nil)
			{
				if (@available(iOS 13.0, *)) 
				{
					UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
					if (mode == UIUserInterfaceStyleDark) 
						//深色模式
						obj.backgroundColor = darkColor;
					
					else
						//浅色模式
						obj.backgroundColor = lightColor;
				}
				else
					obj.backgroundColor = lightColor;
			}
		}
	}];
}
%end

#pragma mark callkit功能

%hook VoipCXMgr
//开启callkit功能
+ (BOOL)isCallkitAvailable
{
    return [WCHLOptions sharedConfig].callKitEnable;
}
+ (BOOL)isDeviceCallkitAvailable
{
    return [WCHLOptions sharedConfig].callKitEnable;
}

%end

#pragma mark 模拟iPad

%hook DeviceInfo
//模拟iPad登录
+ (_Bool)isiPad
{
	return [WCHLOptions sharedConfig].iPadLogin ? YES : %orig;
}
+ (_Bool)isiPadUniversal
{
	return [WCHLOptions sharedConfig].iPadLogin ? YES : %orig;
}
%end

%hook MatrixDeviceInfo
//模拟iPad登录
+ (_Bool)isiPad
{
	return [WCHLOptions sharedConfig].iPadLogin ? YES : %orig;
}
%end


#pragma mark 关闭下拉动态
//8.0.0版本以后不再需要
%hook WCStoryFacade
//"我"下拉视频动态
- (_Bool)shouldShowStory
{
	return [WCHLOptions sharedConfig].showStory ? NO : %orig;
}
%end


#pragma mark 后台高斯模糊

%hook MicroMessengerAppDelegate
//后台高斯模糊
- (void)applicationDidEnterBackground:(UIApplication*)application 
{
	%orig;
	if (![WCHLOptions sharedConfig].blurEffect)
		return;

	if(!_blurView) 
	{
		if (@available(iOS 13.0, *)) 
		{
			UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
			if (mode == UIUserInterfaceStyleDark)
			{
				//深色模式
				UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				_blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
			}
			else
			{
				//浅色模式
				UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				_blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
			}
				
		}
		else
		{
			//非iOS13，无深色模式，给予浅色模糊效果
			UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			_blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		}
		_blurView.frame = self.window.bounds;
	}
	//进入后台实现模糊效果
	[self.window addSubview:_blurView];

	_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
	_footer.backgroundColor = [UIColor whiteColor];
	UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
	lab.text = @"WeChatHookLite全力保护你的信息安全";
	lab.font = [UIFont systemFontOfSize:15];
	lab.textColor = [UIColor grayColor];
	lab.textAlignment = NSTextAlignmentCenter;
	_footer.autoresizingMask = UIViewAutoresizingNone;
	[_footer addSubview:lab];

	[self.window addSubview:_footer];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
	//进入前台
	%orig;
	if (![WCHLOptions sharedConfig].blurEffect)
		return;

	[_footer removeFromSuperview];
	[_blurView removeFromSuperview];

	//设置为nil将导致杀后台
	// [self setFooter:nil];
	// [self setBlurView:nil];
}

%end


#pragma mark 屏蔽越狱检测

%hook NSFileManager
//越狱文件检测
- (BOOL)fileExistsAtPath:(NSString *)path 
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	NSArray<NSString*>* blacklisted = @[
		@"/Applications/Cydia.app",
		@"/bin/sh",
		@"/bin/bash",
		@"/etc/apt",
		@"/etc/ssh/sshd_config",
		@"/Library/MobileSubstrate/DynamicLibraries",
		@"/Library/MobileSubstrate/MobileSubstrate.dylib",
		@"/private/var/lib/apt",
		@"/private/var/lib/cydia",
		@"/private/var/stash",
		@"/private/var/tmp/cydia.log",
		@"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
		@"/usr/bin/sshd",
		@"/usr/bin/ssh",
		@"/usr/sbin/sshd",
		@"/usr/libexec/sftp-server",
		@"/usr/libexec/ssh-keysign",
  	];
	for(NSString* bannedProc in blacklisted)
		if([path containsString:bannedProc])
			return 0;
  
	return %orig(path);
}

%end


%hook UIApplication
//越狱文件检测
- (BOOL)canOpenURL:(NSURL *)url 
{
	BOOL orig = %orig;
	if ([WCHLOptions sharedConfig].jbbypass)
	{
		if([[url absoluteString] isEqualToString:@"cydia://"] 
			|| [[url absoluteString] isEqualToString:@"sileo://"]
			|| [[url absoluteString] isEqualToString:@"zebra://"])
    		orig = NO;
	}

	return orig;
}
%end

%hook JailBreakHelper
//主越狱检测类
+ (id)loadSetting
{
	return [WCHLOptions sharedConfig].jbbypass ? nil : %orig;
}

- (id)init
{
	return [WCHLOptions sharedConfig].jbbypass ? nil : %orig;
}

+ (id)getJailbreakPath
{
	return [WCHLOptions sharedConfig].jbbypass ? nil : %orig;
}

+ (id)getJailbreakRootDir
{
	return [WCHLOptions sharedConfig].jbbypass ? nil : %orig;
}

+ (_Bool)JailBroken
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}

- (_Bool)HasInstallJailbreakPluginInvalidIAPPurchase
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}

- (_Bool)HasInstallJailbreakPlugin:(id)arg1
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}

- (_Bool)IsJailBreak
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}

- (_Bool)isOverADay
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}

%end

%hook CUtility
+ (_Bool)isBeingDebugged
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}
%end

%hook TSEnvironment
+ (_Bool)isBeingDebugged
{
	return [WCHLOptions sharedConfig].jbbypass ? NO : %orig;
}
%end

%hook ClientCheckMgr
//防封号
- (void)reportAppList:(id)arg1
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	return;
}
- (void)checkHookWithSeq:(unsigned int)arg1
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	return;
}
- (void)checkHook:(id)arg1
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	return;
}
- (void)reportFileConsistency:(id)arg1 fileName:(id)arg2 offset:(unsigned int)arg3 bufferSize:(unsigned int)arg4 seq:(unsigned int)arg5
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	return;
}
- (void)checkConsistency:(id)arg1
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	return;
}
%end

%hook WCCrashBlockExtensionHandler
//启动时越狱、bundleID检测
- (void)renewInfoForReport
{
	if (![WCHLOptions sharedConfig].jbbypass)
		return %orig;
	
	return;
}
%end


#pragma mark 去广告


%hook NSURL
//公众号文章广告
+ (id)URLWithString:(NSString *)URLString
{
	id url = %orig;
	if ([WCHLOptions sharedConfig].ads)
	{	
		if([URLString containsString:@"mp.weixin.qq.com/mp/getappmsgad"]
			|| [URLString containsString:@"wxsnsdythumb"]
			|| [URLString containsString:@"ad_data"])
			url = nil;
	}

	return url;
}
%end

%hook WCAdvertiseStorage
//朋友圈广告
- (void)setOAdvertiseData:(NSData *)oAdvertiseData
{
	if (![WCHLOptions sharedConfig].ads)
		return %orig;
	
	return;
}
%end



#pragma mark 消息防撤回

%hook CMessageMgr
//防撤回
- (void)onRevokeMsg:(CMessageWrap *)arg1 
{
	//这里的arg1参数是撤回后的提示内容（XXX撤回了一条消息/你撤回了一条消息）
	//不会拦截自己撤回的消息
	if ([WCHLOptions sharedConfig].revoke)
	{ 
		NSString *msgContent = arg1.m_nsContent;

		NSString *(^parseParam)(NSString *, NSString *,NSString *) = ^NSString *(NSString *content, NSString 				 					*paramBegin,NSString *paramEnd) 
		{
			NSUInteger startIndex = [content rangeOfString:paramBegin].location + paramBegin.length;
			NSUInteger endIndex = [content rangeOfString:paramEnd].location;
			NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
			return [content substringWithRange:range];
		};

		NSString *session = parseParam(msgContent, @"<session>", @"</session>");
		NSString *newmsgid = parseParam(msgContent, @"<newmsgid>", @"</newmsgid>");
		NSString *fromUsrName = parseParam(msgContent, @"<![CDATA[", @"撤回了一条消息");
		CMessageWrap *revokemsg = [self GetMsg:session n64SvrID:[newmsgid integerValue]];

		NSString *newMsgContent = @"";

		if (revokemsg.m_uiMessageType == 1)
			newMsgContent = [NSString stringWithFormat:@"拦截到 %@撤回的消息：\n %@",fromUsrName, revokemsg.m_nsContent];
		else 
			newMsgContent = [NSString stringWithFormat:@"%@撤回的消息被拦截",fromUsrName];

		CMessageWrap *newWrap = 
		({
			CMessageWrap *msg = [[%c(CMessageWrap) alloc] initWithMsgType:0x2710];
			[msg setM_nsFromUsr:revokemsg.m_nsFromUsr];
			[msg setM_nsToUsr:revokemsg.m_nsToUsr];
			[msg setM_uiStatus:0x4];
			[msg setM_nsContent:newMsgContent];
			[msg setM_uiCreateTime:[arg1 m_uiCreateTime]];

			msg;
		});

		[self AddLocalMsg:session MsgWrap:newWrap fixTime:0x1 NewMsgArriveNotify:0x0];

		NSArray *singleArray = [NSArray arrayWithObject:revokemsg];

		if (revokemsg.m_uiMessageType == 1)
		{//文本消息被撤回时，删除被撤回的文本消息
			[self DelMsg:session MsgList:singleArray DelAll:nil];
			return;
		}
		else
		//非文本消息被撤回时，将保留内容
			return;
	}

	%orig;
}

%end



