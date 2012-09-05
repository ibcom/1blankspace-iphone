//
//  FavContactsViewController.h
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class CommonFunctions;


@interface FavContactsViewController : UIViewController <MBProgressHUDDelegate>{

	CommonFunctions *cFunc;
	IBOutlet UITableView *tblView;
	
	NSMutableArray *contactArr;
	NSMutableArray *Indices;
	
	MBProgressHUD *HUD;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tblView;


-(void) loadAllFavContacts;
-(IBAction) addContactBtnPressed:(id) sender;
-(IBAction) refreshBtnPressed:(id) sender;
-(void) syncAndLoadData;

@end
