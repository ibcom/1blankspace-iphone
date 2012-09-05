//
//  SearchContactsViewController.h
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SearchContactsViewController : UIViewController<UISearchBarDelegate,MBProgressHUDDelegate> 
{

	MBProgressHUD *HUD;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tblView;
	
	NSMutableArray *arr;
	
	BOOL HUDisActive;
	
}

@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property(nonatomic,retain) NSMutableArray *arr;

-(void) search;


@end
