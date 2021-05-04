//
//  ViewController.h
//  WCSettingUI
//
//  Created by 排骨 on 2020/8/12.
//  Copyright © 2020 排骨. All rights reserved.
//
#import "WCHLSettingViewController.h"
#import "WCHLViewController.h"
#import "WCHLAboutMeViewController.h"
#import <objc/runtime.h>

@interface CContact: NSObject <NSCoding>

@property(retain, nonatomic) NSString *m_nsUsrName;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;
@property(retain, nonatomic) NSString *m_nsNickName;

- (id)getContactDisplayName;

@end

@protocol ContactSelectViewDelegate <NSObject>

- (void)onSelectContact:(CContact *)arg1;

@end

@interface ContactSelectView : UIView

@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;
@property(nonatomic) _Bool m_bMultiSelect; // @synthesize m_bMultiSelect;
@property(retain, nonatomic) NSMutableDictionary *m_dicMultiSelect; // @synthesize m_dicMultiSelect;

- (id)initWithFrame:(struct CGRect)arg1 delegate:(id)arg2;
- (void)initData:(unsigned int)arg1;
- (void)initView;
- (void)addSelect:(id)arg1;

@end

@interface CContactMgr : NSObject

- (id)getSelfContact;
- (id)getContactByName:(id)arg1;
- (id)getContactForSearchByName:(id)arg1;
- (_Bool)getContactsFromServer:(id)arg1;
- (_Bool)isInContactList:(id)arg1;
- (_Bool)addLocalContact:(id)arg1 listType:(unsigned int)arg2;

@end





@protocol MultiSelectContactsViewControllerDelegate <NSObject>
- (void)onMultiSelectContactReturn:(NSArray *)arg1;

@optional
- (int)getFTSCommonScene;
- (void)onMultiSelectContactCancelForSns;
- (void)onMultiSelectContactReturnForSns:(NSArray *)arg1;
@end

@interface MultiSelectContactsViewController : UIViewController

@property(nonatomic) _Bool m_bKeepCurViewAfterSelect; // @synthesize m_bKeepCurViewAfterSelect=_m_bKeepCurViewAfterSelect;
@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;

@property(nonatomic, weak) id <MultiSelectContactsViewControllerDelegate> m_delegate; // @synthesize m_delegate;

@end

@interface GameController : NSObject
+ (NSString*)getMD5ByGameContent:(NSInteger) content;
@end

@interface CAppViewControllerManager
+ (id)getCurrentNavigationController;
@end


@interface MMLanguageMgr: NSObject
- (id)getStringForCurLanguage:(id)arg1;
@end

@interface MMServiceCenter : NSObject
+ (instancetype)defaultCenter;
- (id)getService:(Class)service;
@end

@interface MMLoadingView : UIView
@property(retain, nonatomic) UILabel *m_label;
@property (assign, nonatomic) BOOL m_bIgnoringInteractionEventsWhenLoading;
- (void)setFitFrame:(long long)arg1;
- (void)startLoading;
- (void)stopLoading;
- (void)stopLoadingAndShowError:(id)arg1;
- (void)stopLoadingAndShowOK:(id)arg1;
@end

@interface UiUtil
+ (double)visibleHeight:(id)arg1;
+ (double)screenWidthCurOri;
@end

@interface WCLocalization
+ (Class)externalIMP;

@end

@interface MMTableViewCell : UITableViewCell
@end


@interface MMTableView : UITableView
- (void)setTableFooterView:(id)arg1;	// IMP=0x0000000107ff3f30
- (void)setTableHeaderView:(id)arg1;
- (void)setContentInset:(struct UIEdgeInsets)arg1;
- (void)reloadData;
@end

@interface MMUICommonUtil
+ (id)getBottomBarButtonWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 style:(unsigned long long)arg4;
+ (id)getBarButtonWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 style:(int)arg4;
@end

@interface WCTableViewManager: UITableView
@property(retain, nonatomic) MMTableView *tableView;
- (void)addTableViewToSuperView:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1 style:(long long)arg2;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;
- (void)addSection:(id)arg1;
- (void)clearAllSection;
- (id)getTableView;
@end


@interface MMTableViewInfo : WCTableViewManager
@end


@interface WCTableView: UIViewController
@end


@interface UINavigationController (LogicController)
- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;
@end


@interface MMUINavigationController : UINavigationController
@end


@interface MMUIViewController : UIViewController
- (void)setTitle:(id)arg1;
- (double)getVisibleHeight;
- (void)initNavHeaderIfNeed;
@end

@interface ContactInfoViewController : MMUIViewController
@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;
@end

@interface NewSettingViewController : MMUIViewController
{
    WCTableViewManager *m_tableViewMgr;
}
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2;
- (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second;

@end

@interface WCTableViewSectionManager
+ (id)defaultSection;
+ (id)sectionInfoDefaut;
+ (id)sectionInfoHeader:(id)arg1 Footer:(id)arg2;
+ (id)sectionInfoFooter:(id)arg1;
+ (id)sectionInfoHeader:(id)arg1;
- (void)addCell:(id)arg1;
@end



@interface WCTableViewCellManager
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 WithDisclosureIndicator:(_Bool)arg5;
+ (id)detailDisclosureButtonCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 canRightValueCopy:(_Bool)arg5;
+ (id)centerCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 detail:(id)arg4;
+ (id)centerCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3;
@end




@interface CMessageWrap
@property(retain, nonatomic) NSString *m_nsContent;
@property(retain, nonatomic) NSString *m_nsToUsr; // @synthesize m_nsToUsr;
@property(retain, nonatomic) NSString *m_nsFromUsr;
@property(nonatomic) unsigned int m_uiCreateTime;
@property(nonatomic) unsigned int m_uiStatus;
@property(nonatomic) unsigned int m_uiMessageType;
+ (_Bool)isSenderFromMsgWrap:(id)arg1;
- (id)initWithMsgType:(long long)arg1;
@end

@interface CMessageMgr
- (void)DelMsg:(id)arg1 MsgList:(id)arg2 DelAll:(_Bool)arg3;
- (void)AddLocalMsg:(id)arg1 MsgWrap:(id)arg2 fixTime:(_Bool)arg3 NewMsgArriveNotify:(_Bool)arg4;
- (void)AddMsg:(id)arg1 MsgWrap:(id)arg2;
- (id)GetMsg:(id)arg1 n64SvrID:(long long)arg2;
@end

@interface ProtobufCGIWrap
@property(retain, nonatomic) CMessageWrap *m_oUserData;
@end

@interface MoreViewController : UIViewController
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2;
- (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second;
@end

@interface MicroMessengerAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIView *footer;
@end
UIVisualEffectView * _visualEffectView;
UIVisualEffectView * _blurView;
UIView *_footer;

@interface MMTitleView : UIView
- (void)setSubTitle:(id)arg1;	// IMP=0x00000001080442b0
- (void)setTitle:(id)arg1;
@end



@interface MMUILabel : UILabel
@property(nonatomic) unsigned long long textStyle;
- (void)setText:(id)arg1;
@end


@interface _UIBarBackground : UIView
@end