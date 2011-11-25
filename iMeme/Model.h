//
//  Model.h
//  iMeme
//
//  Created by Michael Fogleman on 11/21/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject {
    NSString* path;
    NSString* header;
    NSString* footer;
    NSUInteger headerAlignment;
    NSUInteger footerAlignment;
    int headerSize;
    int footerSize;
}

@property (copy) NSString* path;
@property (copy) NSString* header;
@property (copy) NSString* footer;
@property NSUInteger headerAlignment;
@property NSUInteger footerAlignment;
@property int headerSize;
@property int footerSize;

- (void)reset;

@end
