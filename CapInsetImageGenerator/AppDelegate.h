//
//  AppDelegate.h
//  CapInsetImageGenerator
//
//  Created by Ken Cooper on 12/19/12.
//  Copyright (c) 2012 Coopercode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)openClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;


@property (strong, nonatomic) NSImage *sourceImage;
@property (strong, nonatomic) NSImage *destinationImage;
@property (strong, nonatomic) NSString *sourceImageFilename;

@property (strong, nonatomic) NSString *insetsCode;
@end
