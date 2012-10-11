//
//  AppDelegate.h
//  iMeme
//
//  Created by Michael Fogleman on 11/24/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate> {
    NSWindow* _window;
    Model* model;
    NSImageView *imageView;
    NSTableView *tableView;
    NSTextField *header;
    NSTextField *footer;
    NSSegmentedControl *headerAlignment;
    NSSegmentedControl *footerAlignment;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageView;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTextField *header;
@property (assign) IBOutlet NSTextField *footer;
@property (assign) IBOutlet NSSegmentedControl *headerAlignment;
@property (assign) IBOutlet NSSegmentedControl *footerAlignment;

- (void)setPath:(NSString*)aPath;
- (NSString*)upload;
float heightForStringDrawing(NSString *myString, NSFont *myFont, float myWidth);
- (void)drawText:(NSString*)text withRect:(CGRect)rect andPoints:(int)points andAlignment:(NSUInteger)alignment;
- (void)updateImage;

@end
