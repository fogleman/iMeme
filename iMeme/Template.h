//
//  Template.h
//  iMeme
//
//  Created by Michael Fogleman on 11/20/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject {
    NSString *name;
    NSString *path;
}

- (id)initWithName:(NSString*)aName path:(NSString*)aPath;

@property (copy) NSString *name;
@property (copy) NSString *path;

@end
