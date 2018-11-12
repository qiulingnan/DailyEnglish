//
//  AudioSet.m
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/10.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

#import "AudioSet.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioSet

-(void)setAudiu {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

@end
