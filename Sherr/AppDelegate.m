//
//  AppDelegate.m
//  Sherr
//
//  Created by sassembla on 2013/05/11.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "AppDelegate.h"
#define DEFINE_SHELL_SUFFIX (@".sh")

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification * )aNotification {
    //pwdはSharr.appを指す
    //パッケージ内を探索 Sherr.app/*.shを実行する
    NSString * bundlePathName = [[NSBundle mainBundle] bundlePath];

    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bundlePathName]) {
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:bundlePathName isDirectory:(&isDir)];
        if (isDir == YES) {
            for (NSString * shellPath in [fileManager contentsOfDirectoryAtPath:bundlePathName error:nil]) {
                NSLog(@"shellPath %@", shellPath);
                if ([shellPath hasSuffix:DEFINE_SHELL_SUFFIX]) {
                    //パッケージ内に設置してある.shを実行する
                    NSString * m_shellPath = [[NSString alloc]initWithFormat:@"%@/%@", bundlePathName, shellPath];
                    NSLog(@"Sherr:sh %@", m_shellPath);
                    NSTask * task1 = [[NSTask alloc] init];
                    [task1 setLaunchPath:@"/bin/sh"];
                    [task1 setArguments:@[m_shellPath]];
                    [task1 launch];
                    [task1 waitUntilExit];
                    exit(0);
                }
            }
        }
    }
    exit(0);
}

@end
