//
//  _blankspaceContactManagerAppDelegate.h
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface _blankspaceContactManagerAppDelegate : NSObject <UIApplicationDelegate,UITextFieldDelegate,MBProgressHUDDelegate,UITabBarControllerDelegate> {
    UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	
	
	IBOutlet UIScrollView	*scrollView;
	IBOutlet UITextField *Username;
	IBOutlet UITextField *Password;
	IBOutlet UIImageView *CheckImg;
	
	IBOutlet UILabel *username_lbl;
	IBOutlet UILabel *password_lbl;
	IBOutlet UISwitch *rememberSwitch;
	
	IBOutlet UIImageView *topNavBar;
	IBOutlet UIButton *logOnBtn;
	
	BOOL remember;
	BOOL loginError;
	
	MBProgressHUD *HUD;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UITextField *Username;
@property(nonatomic,retain) IBOutlet UITextField *Password;
@property(nonatomic,retain) IBOutlet UIImageView *CheckImg;
@property(nonatomic,retain) IBOutlet UILabel *username_lbl;
@property(nonatomic,retain) IBOutlet UILabel *password_lbl;
@property(nonatomic,retain) IBOutlet UISwitch *rememberSwitch;
@property(nonatomic,retain) IBOutlet UIImageView *topNavBar;
@property(nonatomic,retain) IBOutlet UIButton *logOnBtn;

@property(nonatomic) BOOL remember;
@property(nonatomic) BOOL loginError;

-(void)scrollViewToCenterOfScreen:(UIView *)theView;
-(IBAction) switchValueChanged:(id) sender;
-(IBAction) loginBtnPressed:(id) sender;
-(void) initGlobalVars;
-(void) checkLogin:(id) data;
-(void) autoLogin;
-(void) logout;

@end

