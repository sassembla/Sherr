//
//  Sherr.m
//  Sherr
//
//  Created by sassembla on 2013/05/11.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "Sherr.h"
#import "AppDelegate.h"

@implementation Sherr
int NSApplicationMain(int argc, const char *argv[]) {
    
    AppDelegate * delegate = [[AppDelegate alloc] init];
    
    NSApplication * application = [NSApplication sharedApplication];
    [application setDelegate:delegate];
    
    [NSApp run];
    
    return 0;
}
@end
