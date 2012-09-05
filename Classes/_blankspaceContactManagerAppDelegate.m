//
//  _blankspaceContactManagerAppDelegate.m
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "_blankspaceContactManagerAppDelegate.h"
#import "Config.h"
#import "CommonFunctions.h"
#define DataFilePath                [@"~/Documents/Username_Password.plist" stringByStandardizingPath]


@implementation _blankspaceContactManagerAppDelegate

@synthesize window,tabBarController;
@synthesize scrollView,Username,Password,CheckImg,remember,loginError;
@synthesize username_lbl,password_lbl,rememberSwitch,topNavBar,logOnBtn;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	[self initGlobalVars];
	remember = FALSE;
	[username_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[password_lbl setTextColor:[UIColor colorWithRed:0.3164f green:0.3984f blue:0.5664f alpha:1.0f]];
	[rememberSwitch setOn:FALSE];
	
	[self autoLogin];
    [window makeKeyAndVisible];
	
	return YES;
}


-(void) initGlobalVars{
	
	CommonFunctions * cFunc = [[CommonFunctions alloc] init];
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	DatabasePath = [[documentsDir stringByAppendingPathComponent:DatabaseName] retain];
	NSLog(@"%@",DatabasePath);
	[cFunc checkAndCreateDatabase];
	
}

 

-(IBAction) switchValueChanged:(id) sender{
	
	if (rememberSwitch.on) {
		remember = TRUE;
	}
	else {
		remember = FALSE;
	}

}


-(IBAction) loginBtnPressed:(id) sender{
	
	
	[Username resignFirstResponder];
	[Password resignFirstResponder];
	[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
	
	NSString *usernameTxt = [Username text];
	NSString *passwordTxt = [Password text];
	
	UIAlertView *alertView;
	
	if ([usernameTxt isEqualToString:@""])
	{
		alertView=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Logon Name cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		return;
	}
	if ([passwordTxt isEqualToString:@""])
	{
		alertView=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Password cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		return;
	}
	
	if (remember)
	{
		NSArray *Username_Password_Details = [NSArray arrayWithObjects:usernameTxt,passwordTxt,nil];
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:Username_Password_Details  format:NSPropertyListXMLFormat_v1_0  errorDescription:nil];
		NSLog(@"%@",DataFilePath);
		[data writeToFile:DataFilePath atomically:YES];
		
	}
	
	HUD = [[MBProgressHUD alloc] initWithView:window];
	HUD.graceTime = 0.5;
 
    [window addSubview:HUD];
    HUD.delegate = self;
	[HUD showWhileExecuting:@selector(checkLogin:) onTarget:self withObject:[[NSDictionary alloc] initWithObjectsAndKeys:usernameTxt,@"username",passwordTxt,@"password",nil] animated:YES]; 
	 
	 	
}


-(void) checkLogin:(id) data
{
	NSString *usernameTxt = [data valueForKey:@"username"];
	NSString *passwordTxt = [data valueForKey:@"password"];
	
	
	NSString *loginURL =  [SiteURL stringByAppendingFormat:@"logon.asp?logon=%@&password=%@", usernameTxt, passwordTxt];
	
	NSLog(@"%@",loginURL);
	
	NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:loginURL] encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"%@",URLContent);
	
	loginError = FALSE;
	
	NSArray * resultArr = [URLContent componentsSeparatedByString:@"|"];
	if ([resultArr count]>= 4)
	{
		if ([[resultArr objectAtIndex:3] isEqualToString:@"PASSWORDOK"])
		{
			loginError	= FALSE;
			Sid			  	= [[resultArr objectAtIndex:2] retain];
			
			NSString *userIdURL =  [SiteURL stringByAppendingFormat:@"object.asp?method=CORE_GET_USER_DETAILS"];
			
			NSString *URLContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:userIdURL] encoding:NSUTF8StringEncoding error:nil];
			
			NSLog(@"%@",URLContent);
			
			NSArray * resultArr2 = [URLContent componentsSeparatedByString:@"|"];
			if ([resultArr2 count] >7) {
				UserID = [[resultArr2 objectAtIndex:7] retain];
				requestToReloadFav = TRUE;
			}
			else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to get User Id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}

		}
		else 
		{
			loginError = TRUE;
		}
		
		
	}
	else 
	{
		loginError = TRUE;
	}
	 	
	
	
}

-(void) autoLogin
{
	/* checking if PIN has been already setup */	
	NSData *data = [NSData dataWithContentsOfFile:DataFilePath];
	NSPropertyListFormat format;
	NSArray *array = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:nil];
	
	NSString *userName = [array objectAtIndex:0];
	NSString *passWord = [array objectAtIndex:1];
	NSLog(@"%@",array);
	NSLog(@"%@",DataFilePath);	
	
	if ([array count] > 0) {
		[scrollView setHidden:YES];
		[topNavBar setHidden:TRUE];
		[logOnBtn setHidden:TRUE];
		HUD = [[MBProgressHUD alloc] initWithView:window];
		HUD.graceTime = 0.5;
		
		[window addSubview:HUD];
		HUD.delegate = self;
		[HUD showWhileExecuting:@selector(checkLogin:) onTarget:self withObject:[[NSDictionary alloc] initWithObjectsAndKeys:userName,@"username",passWord,@"password",nil] animated:YES]; 
		
	}
	
}

-(void) logout
{
	// Check for file existence
    if([[NSFileManager defaultManager] fileExistsAtPath:DataFilePath ])
    {
		[[NSFileManager defaultManager] removeItemAtPath:DataFilePath error:nil];
	}
	[scrollView setHidden:FALSE];
	[topNavBar setHidden:FALSE];
	[logOnBtn setHidden:FALSE];
	[Username setText:@""];
	[Password setText:@""];
	[self.tabBarController.view removeFromSuperview];
	[window addSubview:scrollView];
	
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {

	if (loginError)
	{
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Logon Error!" message:@"Logon Name or Password is incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView setDelegate:self];
		[alertView show];
		[alertView release];
		[Username setText:@""];
		[Password setText:@""];
		
	}
	else 
	{
		[window addSubview:tabBarController.view];
	}
	
	
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];  
	
	if ([textField isEqual:Username])
	{
		[Password becomeFirstResponder];
	}
	else 
	{
		[self loginBtnPressed:nil];
	}
	
	return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {  
	
	[self scrollViewToCenterOfScreen:textField];  
	
}  


- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
	
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
    CGFloat availableHeight = applicationFrame.size.height - 300;            // Remove area covered by keyboard  
	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
	
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
	
}
int selectedPrevTab;

- (void)tabBarController:(UITabBarController *)tabBarController1 didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController1.selectedIndex == 2) {
		
        UIAlertView * alertObj=[[UIAlertView alloc] initWithTitle:@"Log Off" message:@"Are you sure you want to Log Off?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertObj show];
        [alertObj release];    
		
        [tabBarController1 setSelectedIndex:selectedPrevTab];
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController1 shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([tabBarController1 selectedIndex]!=2) {
        selectedPrevTab = [tabBarController1 selectedIndex];
    }
    
    //NSLog(@"test");
    // this is called when the user taps a tab bar button,
    // whether it's current or not
    return TRUE;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if ([alertView.title isEqualToString:@"Log Off"]) {
		if (buttonIndex == 1) {
			[self logout];
		}
	}
	else if ([alertView.title isEqualToString:@"Error!"]) {
		
			[self logout];
		
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}





#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
