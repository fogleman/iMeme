//
//  Template.m
//  iMeme
//
//  Created by Michael Fogleman on 11/20/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "Template.h"

@implementation Template

@synthesize name;
@synthesize path;

- (id)initWithName:(NSString*)aName path:(NSString*)aPath {
    self = [super init];
    if (self) {
        self.name = aName;
        self.path = aPath;
    }
    return self;
}

@end
