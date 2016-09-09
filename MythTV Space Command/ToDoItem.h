//
//  ToDoItem.h
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/10/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
