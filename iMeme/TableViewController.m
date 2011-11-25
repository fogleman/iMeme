//
//  TableViewController.m
//  iMeme
//
//  Created by Michael Fogleman on 11/24/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "TableViewController.h"
#import "Template.h"

@implementation TableViewController
@synthesize appDelegate;
@synthesize tableView;

- (id)init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
        NSArray* paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpeg" inDirectory:nil];
        for (NSString* filename in paths) {
            NSString* path = [[filename lastPathComponent] stringByDeletingPathExtension];
            NSString* name = [[path stringByReplacingOccurrencesOfString:@"-" withString:@" "] capitalizedString];
            path = [[NSBundle mainBundle] pathForImageResource:path];
            [items addObject:[[Template alloc] initWithName:name path:path]];
        }
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [items count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    Template* template = [items objectAtIndex:row];
    NSString* identifier = [tableColumn identifier];
    return [template valueForKey:identifier];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    Template* template = [items objectAtIndex:[tableView selectedRow]];
    [appDelegate setPath:[template path]];
}

@end
