//
//  AllContactsViewController.h
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AllContactsViewController : UIViewController<MBProgressHUDDelegate> 
{
	MBProgressHUD *HUD;
	IBOutlet UITableView *tblView;
	NSMutableArray *ContactsArr;
}

@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property(nonatomic,retain) NSMutableArray *ContactsArr;

@end
