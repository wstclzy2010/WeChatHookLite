//
//  WCHLOptions.h
//  WCSettingUI
//
//  Created by 排骨 on 2020/8/4.
//  Copyright © 2020 排骨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCHLOptions : NSObject

+ (instancetype)sharedConfig;

@property (assign, nonatomic) BOOL jbbypass;
@property (assign, nonatomic) BOOL ads;
@property (assign, nonatomic) BOOL revoke;
@property (assign, nonatomic) BOOL blurEffect;
@property (assign, nonatomic) BOOL showStory;
@property (assign, nonatomic) BOOL iPadLogin;
@property (assign, nonatomic) BOOL callKitEnable;

@end

NS_ASSUME_NONNULL_END
