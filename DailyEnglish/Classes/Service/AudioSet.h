//
//  AudioSet.h
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/10.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioSet : NSObject

+(void)setAudiu;
+(void)resetAudiu;

+(NSMutableData*)pcm_to_wav :(NSString *)path sampleRate:(long)sampleRate;

@end

NS_ASSUME_NONNULL_END
