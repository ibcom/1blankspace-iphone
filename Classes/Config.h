//
//  Config.h
//  1blankspaceContactManager
//
//  Created by Konstant on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Config : NSObject {

}

extern  NSString		*SiteURL;
extern  NSString		*DatabaseName;
extern  NSString		*DatabasePath;


extern  NSString		*Sid;
extern  NSString		*UserID;
extern	BOOL			requestToReloadFav;
extern	BOOL			contactIsBeingEdited;

@end
