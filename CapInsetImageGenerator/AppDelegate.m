//
//  AppDelegate.m
//  CapInsetImageGenerator
//
//  Created by Ken Cooper on 12/19/12.
//  Copyright (c) 2012 Coopercode. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSDictionary *defaults = @{
        @"topEdgeInset" : @(3),
        @"leftEdgeInset" : @(3),
        @"bottomEdgeInset" : @(3),
        @"rightEdgeInset" : @(3),
        @"verticalFillWidth" : @(1),
        @"horizontalFillWidth" : @(1),
        @"sourceIsRetina" : @(YES)
    };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaults];
    
    for (NSString *insetName in @[@"top", @"left",@"bottom",@"right"]) {
        [[NSUserDefaults standardUserDefaults] addObserver: self
               forKeyPath: [NSString stringWithFormat:@"%@EdgeInset", insetName]
                  options: NSKeyValueObservingOptionNew
                  context: NULL];
    }
    [[NSUserDefaults standardUserDefaults] addObserver: self
                                                              forKeyPath: @"sourceIsRetina"
                                                                 options: NSKeyValueObservingOptionNew
                                                                 context: NULL];
    
    [self addObserver: self
           forKeyPath: @"sourceImage"
              options: NSKeyValueObservingOptionNew
              context: NULL];

    [self generateInsetsCode];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self generateDestinationImage];
    [self generateInsetsCode];
}

-(void)generateInsetsCode
{
    self.insetsCode = [NSString stringWithFormat:@"UIEdgetInsetsMake(%.1f,%.1f,%.1f,%.1f)",
                           [[NSUserDefaults standardUserDefaults] floatForKey:@"leftEdgeInset"],
                           [[NSUserDefaults standardUserDefaults] floatForKey:@"topEdgeInset"],
                           [[NSUserDefaults standardUserDefaults] floatForKey:@"bottomEdgeInset"],
                           [[NSUserDefaults standardUserDefaults] floatForKey:@"rightEdgeInset"]
                       ];
}
-(void)generateDestinationImage
{
    
    CGFloat leftEdgeInsetPixels = [[NSUserDefaults standardUserDefaults] floatForKey:@"leftEdgeInset"];
    CGFloat topEdgeInsetPixels = [[NSUserDefaults standardUserDefaults] floatForKey:@"topEdgeInset"];
    CGFloat bottomEdgeInsetPixels = [[NSUserDefaults standardUserDefaults] floatForKey:@"bottomEdgeInset"];
    CGFloat rightEdgeInsetPixels = [[NSUserDefaults standardUserDefaults] floatForKey:@"rightEdgeInset"];
    CGFloat horizontalFillWidthPixels = [[NSUserDefaults standardUserDefaults] floatForKey:@"horizontalFillWidth"];
    CGFloat verticalFillWidthPixels = [[NSUserDefaults standardUserDefaults] floatForKey:@"verticalFillWidth"];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sourceIsRetina"]) {
        leftEdgeInsetPixels *= 2;
        topEdgeInsetPixels *= 2;
        bottomEdgeInsetPixels *= 2;
        rightEdgeInsetPixels *= 2;
        horizontalFillWidthPixels *= 2;
        verticalFillWidthPixels *= 2;
    }
    
    NSImage *destImage = [[NSImage alloc]initWithSize:(NSMakeSize(leftEdgeInsetPixels + horizontalFillWidthPixels + rightEdgeInsetPixels, topEdgeInsetPixels + verticalFillWidthPixels + bottomEdgeInsetPixels))];
    
    [destImage lockFocus];
    
    // Top Left
    [self.sourceImage drawInRect:NSMakeRect(0,
                                            0,
                                            leftEdgeInsetPixels,
                                            topEdgeInsetPixels)
                        fromRect:NSMakeRect(0,
                                            0,
                                            leftEdgeInsetPixels,
                                            topEdgeInsetPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    // Top Middle
    [self.sourceImage drawInRect:NSMakeRect(leftEdgeInsetPixels,
                                            0,
                                            horizontalFillWidthPixels,
                                            topEdgeInsetPixels)
                        fromRect:NSMakeRect(leftEdgeInsetPixels,
                                            0,
                                            horizontalFillWidthPixels,
                                            topEdgeInsetPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    // Top Right
    [self.sourceImage drawInRect:NSMakeRect(leftEdgeInsetPixels + horizontalFillWidthPixels,
                                            0,
                                            rightEdgeInsetPixels,
                                            topEdgeInsetPixels)
                        fromRect:NSMakeRect(self.sourceImage.size.width - rightEdgeInsetPixels,
                                            0,
                                            rightEdgeInsetPixels,
                                            topEdgeInsetPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    // Middle Left
    [self.sourceImage drawInRect:NSMakeRect(0,
                                            topEdgeInsetPixels,
                                            leftEdgeInsetPixels,
                                            verticalFillWidthPixels)
                        fromRect:NSMakeRect(0,
                                            topEdgeInsetPixels,
                                            leftEdgeInsetPixels,
                                            verticalFillWidthPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    // Middle Middle
    [self.sourceImage drawInRect:NSMakeRect(leftEdgeInsetPixels,
                                            topEdgeInsetPixels,
                                            horizontalFillWidthPixels,
                                            verticalFillWidthPixels)
                        fromRect:NSMakeRect(leftEdgeInsetPixels,
                                            topEdgeInsetPixels,
                                            horizontalFillWidthPixels,
                                            verticalFillWidthPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    // Middle Right
    [self.sourceImage drawInRect:NSMakeRect(leftEdgeInsetPixels + horizontalFillWidthPixels,
                                            topEdgeInsetPixels,
                                            rightEdgeInsetPixels,
                                            verticalFillWidthPixels)
                        fromRect:NSMakeRect(self.sourceImage.size.width - rightEdgeInsetPixels,
                                            topEdgeInsetPixels,
                                            rightEdgeInsetPixels,
                                            verticalFillWidthPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    // Bottom Left
    [self.sourceImage drawInRect:NSMakeRect(0,
                                            topEdgeInsetPixels+verticalFillWidthPixels,
                                            leftEdgeInsetPixels,
                                            bottomEdgeInsetPixels)
                        fromRect:NSMakeRect(0,
                                            self.sourceImage.size.height-bottomEdgeInsetPixels,
                                            leftEdgeInsetPixels,
                                            bottomEdgeInsetPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    // Bottom Middle
    [self.sourceImage drawInRect:NSMakeRect(leftEdgeInsetPixels,
                                            topEdgeInsetPixels+verticalFillWidthPixels,
                                            horizontalFillWidthPixels,
                                            bottomEdgeInsetPixels)
                        fromRect:NSMakeRect(leftEdgeInsetPixels,
                                            self.sourceImage.size.height-bottomEdgeInsetPixels,
                                            horizontalFillWidthPixels,
                                            bottomEdgeInsetPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    // Bottom Right
    [self.sourceImage drawInRect:NSMakeRect(leftEdgeInsetPixels + horizontalFillWidthPixels,
                                            topEdgeInsetPixels+verticalFillWidthPixels,
                                            rightEdgeInsetPixels,
                                            bottomEdgeInsetPixels)
                        fromRect:NSMakeRect(self.sourceImage.size.width - rightEdgeInsetPixels,
                                            self.sourceImage.size.height-bottomEdgeInsetPixels,
                                            rightEdgeInsetPixels,
                                            bottomEdgeInsetPixels)
                       operation:NSCompositeCopy
                        fraction:1];
    
    [destImage unlockFocus];
    
    self.destinationImage = destImage;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    self.sourceImage = [[NSImage alloc]initWithContentsOfFile:filename];
    return YES;
}

- (IBAction)openClicked:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = @[@"png"];
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  imageURL = [[panel URLs] objectAtIndex:0];
            [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:imageURL];
            self.sourceImageFilename = imageURL.pathComponents[imageURL.pathComponents.count - 1];
            self.sourceImage = [[NSImage alloc]initWithContentsOfURL:imageURL];
        }
    }];
}

- (IBAction)saveClicked:(id)sender {
    
    NSSavePanel *save = [NSSavePanel savePanel];
    save.allowedFileTypes = @[@"png"];
    save.allowsOtherFileTypes = NO;
    save.nameFieldStringValue = [NSString stringWithFormat:@"%@.png", self.sourceImageFilename ? self.sourceImageFilename : @"resizable_image"];
    
    if ([save runModal] == NSOKButton) {
        NSData *imageData = [self.destinationImage TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];        
        
        NSString *path = [[save URL] path];
        NSError *error;
        [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
        [imageData writeToFile: path atomically: NO];
        if (error) {
            [NSApp presentError:error];
        }
    }
}
@end
