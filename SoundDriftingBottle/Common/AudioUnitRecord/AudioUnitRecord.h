//
//  AudioUnitRecord.h
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioUnitRecord : NSObject
{
@public
AudioComponent _audioComponment;
AudioComponentInstance _audioUint;
AudioStreamBasicDescription _asbd;
//播放音频队列
AudioQueueRef _audioQueue;
//音频缓存
AudioQueueBufferRef _audioQueueBuffers[3];
BOOL _audioQueueUsed[3];
int _index;
}

- (void)initializeAudio;
- (void)earReturnStart;
- (void)earReturnStop;
- (void)configAudio;
- (void)didClickStartOrStop;

@end

NS_ASSUME_NONNULL_END
