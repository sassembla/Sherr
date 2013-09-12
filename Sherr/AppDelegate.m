//
//  AppDelegate.m
//  Sherr
//
//  Created by sassembla on 2013/05/11.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "AppDelegate.h"
#define DEFINE_SHELL_SUFFIX		(@".sh")

#define KEY_SHERR_IDENTITY		(@"sherr")

@implementation AppDelegate


//life time
NSTimeInterval m_restCount;
NSTimeInterval resetSecondsValue;
NSTimeInterval lifeTimeUnit = 1.0;//(sec


int m_mode;
#define MODE_REDUCE	(0)
#define MODE_RUNNING	(1)


- (void)applicationDidFinishLaunching:(NSNotification * )aNotification {
    //アプリケーションとして実行した場合のpwdは/を指す
    //パッケージ内を探索 Sherr.app/*.shを実行する
    
	
    // set observer for recursive-run
    [[NSDistributedNotificationCenter defaultCenter]addObserver:self selector:@selector(receiver:) name:KEY_SHERR_IDENTITY object:nil];
    
    
    NSData * data;
    NSError * error;
    
    
    // load settings
//    id a = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    settingDict = [[NSDictionary alloc]initWithContentsOfFile:<#(NSString *)#>];
	resetSecondsValue = 10;
    
	// start only-one reduce loop
	[self performSelector:@selector(reduceCount) withObject:nil afterDelay:1.0];
	
    // run local shell
    [self runShell:[[NSBundle mainBundle] bundlePath]];
}

/**
 run shell in the app
 */
- (void) runShell:(NSString * )bundlePathName {
	
	m_mode = MODE_RUNNING;
	
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bundlePathName]) {
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:bundlePathName isDirectory:(&isDir)];
        if (isDir == YES) {
            
            NSString * stepladder = [[NSString alloc]initWithFormat:@"%@/Contents/Resources/%@", bundlePathName, @"stepladderShell.sh"];
            
            for (NSString * shellPath in [fileManager contentsOfDirectoryAtPath:bundlePathName error:nil]) {
                NSLog(@"shellPath %@", shellPath);
                
                
                if ([shellPath hasSuffix:DEFINE_SHELL_SUFFIX]) {
                    //パッケージ内に設置してある.shを実行するshellを呼び出す。cdを外部で行い、そこを起点にする必要がある。
                    
                    NSString * m_shellPath = [[NSString alloc]initWithFormat:@"%@/%@", bundlePathName, shellPath];
                    NSLog(@"Sherr:sh %@", m_shellPath);
                    
					NSTask * task1 = [[NSTask alloc] init];
					[task1 setLaunchPath:@"/bin/sh"];
					[task1 setArguments:@[stepladder, bundlePathName, shellPath]];
					[task1 launch];
					[task1 waitUntilExit];
					
					// reset life
					m_restCount = resetSecondsValue;
					m_mode = MODE_REDUCE;
					
					return;
                }
            }
        }
    }
	
	NSLog(@"no *.sh in Sherr.app");
	exit(0);
}



- (void) reduceCount {
	switch (m_mode) {
		case MODE_REDUCE:{
			m_restCount -= lifeTimeUnit;
			
			if (m_restCount <= 0) exit(0);
			else [self performSelector:@selector(reduceCount) withObject:nil afterDelay:1.0];

			break;
		}
			
		default:{
			// do nothing
			break;
		}
	
	}
}


/**
 notification受け取り時の動作
 */
- (void) receiver:(NSNotification * )notif {
    [self runShell:[[NSBundle mainBundle] bundlePath]];
}


@end
