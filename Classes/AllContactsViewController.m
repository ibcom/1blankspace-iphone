//
//  AllContactsViewController.m
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AllContactsViewController.h"
#import "Config.h"
#import "TBXML.h"
#import "Contact.h"

@implementation AllContactsViewController

@synthesize tblView,ContactsArr;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.graceTime = 0.5;
	HUD.navigationBar = self.navigationController.navigationBar;
    [self.view addSubview:HUD];
    HUD.delegate = self;
	[HUD showWhileExecuting:@selector(loadAllContacts) onTarget:self withObject:@"0" animated:YES]; 
	
	
}


-(void)  loadAllContacts{
	
	// https://secure.mydigitalspacelive.com/directory/ondemand/object.asp?sid=143500838-k-38364da989c5d1f1abc578af88945dbc&method=PERSON_SEARCH
	NSString *url = [SiteURL stringByAppendingFormat:@"object.asp?sid=%@&method=PERSON_SEARCH",Sid];
	
	NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
	
	NSArray *responseArr = [response componentsSeparatedByString:@"|"];

	ContactsArr = [[NSMutableArray alloc] init];
	
	if ([[responseArr objectAtIndex:0] isEqualToString:@"OK"])
	{
		
		TBXML * tbxml = [[TBXML alloc] initWithXMLString:[responseArr objectAtIndex:1]];
		TBXMLElement * root = tbxml.rootXMLElement; 
		
		if (root) 
		{  
			
			TBXMLElement *row	= [tbxml childElementNamed:@"row" parentElement:root];
			
			while (row != nil)
			{ 
				
				//NSString * rownumber			= [tbxml valueOfAttributeNamed:@"rownumber" forElement:row];
				//NSString * rowcount				= [tbxml valueOfAttributeNamed:@"rowcount" forElement:row];
				//NSString * reference			= [tbxml valueOfAttributeNamed:@"reference" forElement:row];
				NSString * id					= [tbxml valueOfAttributeNamed:@"id" forElement:row];
				//NSString * contbusinessid		= [tbxml valueOfAttributeNamed:@"contbusinessid" forElement:row];
				NSString * firstname			= [tbxml valueOfAttributeNamed:@"firstname" forElement:row];
				NSString * surname				= [tbxml valueOfAttributeNamed:@"surname" forElement:row];
				NSString * streetaddress1		= [tbxml valueOfAttributeNamed:@"streetaddress1" forElement:row];
				NSString * streetaddress2		= [tbxml valueOfAttributeNamed:@"streetaddress2" forElement:row];
				NSString * streetsuburb			= [tbxml valueOfAttributeNamed:@"streetsuburb" forElement:row];
				NSString * streetstate			= [tbxml valueOfAttributeNamed:@"streetstate" forElement:row];
				NSString * streetpostcode		= [tbxml valueOfAttributeNamed:@"streetpostcode" forElement:row];
				NSString * streetcountry		= [tbxml valueOfAttributeNamed:@"streetcountry" forElement:row];
				NSString * email				= [tbxml valueOfAttributeNamed:@"email" forElement:row];
				//NSString * homephone			= [tbxml valueOfAttributeNamed:@"homephone" forElement:row];
				NSString * phone				= [tbxml valueOfAttributeNamed:@"phone" forElement:row];
				NSString * mobile				= [tbxml valueOfAttributeNamed:@"mobile" forElement:row];
				NSString * bestcontactonphone	= [tbxml valueOfAttributeNamed:@"bestcontactonphone" forElement:row];
				NSString * skype				= [tbxml valueOfAttributeNamed:@"skype" forElement:row];
				NSString * dateofbirth			= [tbxml valueOfAttributeNamed:@"dateofbirth" forElement:row];
				//NSString * age					= [tbxml valueOfAttributeNamed:@"age" forElement:row];
				NSString * gender				= [tbxml valueOfAttributeNamed:@"gender" forElement:row];
				//NSString * genderttext			= [tbxml valueOfAttributeNamed:@"genderttext" forElement:row];
				//NSString * gendertext			= [tbxml valueOfAttributeNamed:@"gendertext" forElement:row];
				//NSString * minutesfromutc		= [tbxml valueOfAttributeNamed:@"minutesfromutc" forElement:row];
				//NSString * localtime			= [tbxml valueOfAttributeNamed:@"localtime" forElement:row];	
				//NSString * relationshipcount	= [tbxml valueOfAttributeNamed:@"relationshipcount" forElement:row];
				
				 				
				Contact *contact = [[Contact alloc] init];
				contact.id						= id;					
				contact.firstname				= firstname;			
				contact.surname					= surname;				
				contact.streetaddress1			= streetaddress1;		
				contact.streetaddress2			= streetaddress2;		
				contact.streetsuburb			= streetsuburb;			
				contact.streetstate				= streetstate;			
				contact.streetpostcode			= streetpostcode;		
				contact.streetcountry			= streetcountry;		
				contact.email					= email;				
				contact.phone					= phone;				
				contact.mobile					= mobile;				
				contact.bestcontactonphone		= bestcontactonphone;	
				contact.skype					= skype;				
				contact.dateofbirth				= dateofbirth;			
				contact.gender					= gender;				
				
				[ContactsArr addObject:contact];
				
				row = [tbxml nextSiblingNamed:@"row" searchFromElement:row];
				
			}
			
			
		}
		
		
	}

	
	
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
	
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}
 

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
    [super dealloc];
}


@end
