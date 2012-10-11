//
//  Model.m
//  iMeme
//
//  Created by Michael Fogleman on 11/21/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize path;
@synthesize header;
@synthesize footer;
@synthesize headerAlignment;
@synthesize footerAlignment;
@synthesize headerSize;
@synthesize footerSize;

- (id)init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)reset {
    self.path = [[NSBundle mainBundle] pathForImageResource:@"startup"];
    self.header = @"";
    self.footer = @"";
    self.headerAlignment = NSCenterTextAlignment;
    self.footerAlignment = NSCenterTextAlignment;
    self.headerSize = 48;
    self.footerSize = 48;
}

@end
