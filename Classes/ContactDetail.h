//
//  ContactDetail.h
//  1blankspaceContactManager
//
//  Created by Konstant on 14/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;


@interface ContactDetail : UIViewController<UIActionSheetDelegate> {

	Contact *contact;
	IBOutlet UITableView *tblView;
	UIButton *addAsfavBtn;
	
	BOOL isFav;
}

@property (nonatomic,retain) Contact *contact;
@property (nonatomic,retain) IBOutlet UITableView *tblView;

-(IBAction) emailBtnPressed:(id) sender;
-(IBAction) favBtnPressed:(id) sender;
-(IBAction) mapBtnPressed:(id) sender;
-(void) checkForFav;
@end
