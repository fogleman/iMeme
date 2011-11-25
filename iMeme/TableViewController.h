//
//  TableViewController.h
//  iMeme
//
//  Created by Michael Fogleman on 11/24/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface TableViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    NSMutableArray* items;
    AppDelegate* appDelegate;
    NSTableView* tableView;
}

@property (assign) IBOutlet AppDelegate* appDelegate;
@property (assign) IBOutlet NSTableView* tableView;

@end
