//
//  WCHLOptions.m
//  WCSettingUI
//
//  Created by 排骨 on 2020/8/4.
//  Copyright © 2020 排骨. All rights reserved.
//

#import "WCHLOptions.h"
#define WCDefaults [NSUserDefaults standardUserDefaults]

static NSString * const wcjbbypass = @"jbbypass";
static NSString * const wcads = @"ads";
static NSString * const wcrevoke = @"revoke";
static NSString * const wcblurEffect = @"blurEffect";
static NSString * const wcshowStory = @"showStory";
static NSString * const wciPadLogin = @"iPadLogin";
static NSString * const wccallKitEnable = @"callKitEnable";

@implementation WCHLOptions

+ (instancetype)sharedConfig
{
    static WCHLOptions *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[WCHLOptions alloc] init];
    });
    return config;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _jbbypass = [WCDefaults boolForKey:wcjbbypass];
        _ads = [WCDefaults boolForKey:wcads];
        _revoke = [WCDefaults boolForKey:wcrevoke];
        _blurEffect = [WCDefaults boolForKey:wcblurEffect];
        _showStory = [WCDefaults boolForKey:wcshowStory];
        _iPadLogin = [WCDefaults boolForKey:wciPadLogin];
        _callKitEnable = [WCDefaults boolForKey:wccallKitEnable];
    }
    return self;
}

- (void)setJbbypass:(BOOL)jbbypass
{
    _jbbypass = jbbypass;
    [WCDefaults setBool:jbbypass forKey:wcjbbypass];
    [WCDefaults synchronize];
}

- (void)setAds:(BOOL)ads
{
    _ads = ads;
    [WCDefaults setBool:ads forKey:wcads];
    [WCDefaults synchronize];
}

- (void)setRevoke:(BOOL)revoke
{
    _revoke = revoke;
    [WCDefaults setBool:revoke forKey:wcrevoke];
    [WCDefaults synchronize];
}

- (void)setBlurEffect:(BOOL)blurEffect
{
    _blurEffect = blurEffect;
    [WCDefaults setBool:blurEffect forKey:wcblurEffect];
    [WCDefaults synchronize];
}

- (void)setShowStory:(BOOL)showStory
{
    _showStory = showStory;
    [WCDefaults setBool:showStory forKey:wcshowStory];
    [WCDefaults synchronize];
}

- (void)setIPadLogin:(BOOL)iPadLogin
{
    _iPadLogin = iPadLogin;
    [WCDefaults setBool:iPadLogin forKey:wciPadLogin];
    [WCDefaults synchronize];
}

- (void)setCallKitEnable:(BOOL)callKitEnable
{
    _callKitEnable = callKitEnable;
    [WCDefaults setBool:callKitEnable forKey:wccallKitEnable];
    [WCDefaults synchronize];
}

@end
