//
//  AppDelegate.m
//  iMeme
//
//  Created by Michael Fogleman on 11/24/11.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "AppDelegate.h"
#import "MultipartForm.h"
#import "SBJson.h"
#import "NSData+Base64.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize imageView;
@synthesize tableView;
@synthesize header;
@synthesize footer;
@synthesize headerAlignment;
@synthesize footerAlignment;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    model = [[Model alloc] init];
//    [self updateImage];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender {
    return YES;
}

- (NSData*)getPNG {
    NSData* imageData = [[imageView image] TIFFRepresentation];
    NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:imageData];
    NSData* data = [rep representationUsingType:NSPNGFileType properties:nil];
    return data;
}

- (NSData*)getJPG {
    NSData* imageData = [[imageView image] TIFFRepresentation];
    NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:imageData];
    NSData* data = [rep representationUsingType:NSJPEGFileType properties:nil];
    return data;
}

- (NSData*)getTIF {
    NSData* imageData = [[imageView image] TIFFRepresentation];
    NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:imageData];
    NSData* data = [rep representationUsingType:NSTIFFFileType properties:nil];
    return data;
}



- (void)setPath:(NSString*)aPath {
    model.path = aPath;
    [self updateImage];
}

- (void)controlTextDidChange:(NSNotification*)aNotification {
    model.header = [[header stringValue] uppercaseString];
    model.footer = [[footer stringValue] uppercaseString];
    [self updateImage];
}

- (IBAction)onHeaderSize:(NSSegmentedControl*)sender {
    NSInteger segment = [sender selectedSegment];
    NSInteger tag = [[sender cell] tagForSegment:segment];
    model.headerSize += tag ? 4 : -4;
    model.headerSize = MAX(model.headerSize, 8);
    model.headerSize = MIN(model.headerSize, 144);
    [self updateImage];
}

- (IBAction)onFooterSize:(NSSegmentedControl*)sender {
    NSInteger segment = [sender selectedSegment];
    NSInteger tag = [[sender cell] tagForSegment:segment];
    model.footerSize += tag ? 4 : -4;
    model.footerSize = MAX(model.footerSize, 8);
    model.footerSize = MIN(model.footerSize, 144);
    [self updateImage];
}

- (IBAction)onHeaderAlignment:(NSSegmentedControl*)sender {
    NSInteger segment = [sender selectedSegment];
    NSInteger tag = [[sender cell] tagForSegment:segment];
    model.headerAlignment = tag;
    [self updateImage];
}

- (IBAction)onFooterAlignment:(NSSegmentedControl*)sender {
    NSInteger segment = [sender selectedSegment];
    NSInteger tag = [[sender cell] tagForSegment:segment];
    model.footerAlignment = tag;
    [self updateImage];
}



- (IBAction)onSave:(id)sender {
    NSSavePanel* panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"jpg", nil]];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        NSData* data = [self getJPG];
        [data writeToURL:[panel URL] atomically:YES];
    }
}

- (IBAction)onOpen:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"png", @"jpg", @"jpeg", @"bmp", @"gif", nil]];
    [panel setAllowsMultipleSelection:NO];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        NSURL* url = [[panel URLs] objectAtIndex:0];
        [self setPath:[url path]];
    }
}

- (IBAction)onCopy:(id)sender {
    NSPasteboard* board = [NSPasteboard generalPasteboard];
    NSData* data = [self getTIF];
    [board clearContents];
    [board setData:data forType:NSTIFFPboardType];
}

- (IBAction)copy:(id)sender {
    [self onCopy:sender];
}

- (IBAction)onReset:(id)sender {
    [tableView deselectAll:nil];
    [model reset];
    [headerAlignment selectSegmentWithTag:model.headerAlignment];
    [footerAlignment selectSegmentWithTag:model.footerAlignment];
    [header setStringValue:model.header];
    [footer setStringValue:model.footer];
    [self updateImage];
}

- (IBAction)onImgur:(id)sender {
    NSString* url = [self upload];
    if (url) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
    }
}

- (IBAction)onReddit:(id)sender {
    NSString* url = [self upload];
    if (url) {
        NSString* redditBaseUrl = @"http://www.reddit.com/r/AdviceAnimals/submit?url=";
        NSString* redditUrl = [redditBaseUrl stringByAppendingString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:redditUrl]];
    }
}

- (IBAction)onWebsite:(id)sender {
    NSString* url = @"http://www.michaelfogleman.com/imeme/";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}



- (NSString *)upload {
    // TODO: asynchronous
    NSString *imageData = [[self getJPG] base64EncodedString];
    NSURL *url = [NSURL URLWithString:@"http://api.imgur.com/2/upload.json"];
    MultipartForm *form = [[[MultipartForm alloc] initWithURL:url] autorelease];
    [form addFormField:@"key" withStringData:@"ba24197a8c1cbcff577fcad9bcfe0268"];
    [form addFormField:@"image" withStringData:imageData];
    [form addFormField:@"type" withStringData:@"base64"];
    NSMutableURLRequest *postRequest = [form mpfRequest];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
    if (!data) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:_window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        return nil;
    }
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSDictionary *object = [parser objectWithData:data];
    NSString *result = [[[object valueForKey:@"upload"] valueForKey:@"links"] valueForKey:@"original"];
    return result;
}



float heightForStringDrawing(NSString* myString, NSFont* myFont, float myWidth) {
    NSTextStorage* textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer* textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    NSLayoutManager* layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager usedRectForTextContainer:textContainer].size.height;
}

- (void)drawText:(NSString *)text withRect:(CGRect)rect andPoints:(int)points andAlignment:(NSUInteger)alignment {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    NSFont *font = [NSFont fontWithName:@"Impact" size:points];
    [attrs setValue:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle *style = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [style setAlignment:alignment];
    [style setMaximumLineHeight:points * 1.2f];
    [attrs setValue:style forKey:NSParagraphStyleAttributeName];
    [attrs setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
    int n = 3;
    for (int dy = -n; dy <= n; dy++) {
        for (int dx = -n; dx <= n; dx++) {
            if (dx * dx + dy * dy > (n + 1) * (n + 1)) {
                continue;
            }
            [text drawInRect:NSRectFromCGRect(CGRectOffset(rect, dx, dy)) withAttributes:attrs];
        }
    }
    [attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
    [text drawInRect:NSRectFromCGRect(rect) withAttributes:attrs];
}

- (void)updateImage {
    NSImage* image = [[NSImage alloc] initWithContentsOfFile:model.path];
    [image lockFocus];
    NSSize size = [image size];
    int pad = 10;
    int width = size.width - pad * 2;
    int height;
    CGRect rect;
    // header
    height = size.height - pad * 2;
    rect = CGRectMake(pad, pad, width, height);
    [self drawText:model.header withRect:rect andPoints:model.headerSize andAlignment:model.headerAlignment];
    // footer
    NSFont* font = [NSFont fontWithName:@"Impact" size:model.footerSize];
    height = heightForStringDrawing(model.footer, font, width);
    rect = CGRectMake(pad, pad, width, height);
    [self drawText:model.footer withRect:rect andPoints:model.footerSize andAlignment:model.footerAlignment];
    [image unlockFocus];
    
    [imageView setImage:image];
    [image release];
}

@end
