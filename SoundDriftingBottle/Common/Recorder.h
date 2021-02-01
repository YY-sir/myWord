//
//  Recorder.h
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Recorder : NSObject
//将pcm格式音频转成mp3
- ( NSString* )audio_PCMtoMP3_pathIN:(NSString*)pathIn pathOut:(NSString*)pathOut;

//降噪
- ( NSString* ) noiseSuppressPath:(NSString*)pathIn pathOut:(NSString*)pathOut;

//变声
- ( NSString* ) soundChangePathIn:(NSString*)pathIn pathOut:(NSString*)pathOut soundNumber:(int)number;
@end

NS_ASSUME_NONNULL_END
