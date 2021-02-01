//
//  Recorder.m
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/1.
//
#import <Foundation/Foundation.h>
#import "lame.h"
#import "Recorder.h"
#import "sound_change_api.h"
#import "agc_process_api.h"
#import "noise_suppress_api.h"
#import "audio_common.h"

@implementation Recorder
//将pcm格式音频转成mp3
- ( NSString* )audio_PCMtoMP3_pathIN:(NSString*)pathIn pathOut:(NSString*)pathOut
{
    NSString *mp3FilePath = [[NSString alloc] initWithString:pathOut];
    NSLog(@"pathOut-mp3:%@",mp3FilePath);

    @try {
        int read, write;
       
        FILE *pcm = fopen ([ pathIn cStringUsingEncoding : 1 ], "rb" );  //source 被转换的音频文件位置
        fseek (pcm, 4 * 1024 , SEEK_CUR );                                   //skip file header
        FILE *mp3 = fopen ([mp3FilePath cStringUsingEncoding : 1 ], "wb" );  //output 输出生成的 Mp3 文件位置
       
        const int PCM_SIZE = 8192 ; //8192
        const int MP3_SIZE = 8192 ; //8192
        short int pcm_buffer[PCM_SIZE* 2 ];
        unsigned char mp3_buffer[MP3_SIZE];
       
        lame_t lame = lame_init ();
        lame_set_in_samplerate (lame, 22050.0 ); // 采样播音速度，值越大播报速度越快，反之。
        lame_set_VBR (lame, vbr_default );
        lame_init_params (lame);
       
        do {
            read = (int)fread (pcm_buffer, 2 * sizeof ( short int ), PCM_SIZE, pcm);
            if (read == 0 )
            {
                write = lame_encode_flush (lame, mp3_buffer, MP3_SIZE);
            }
            else{
                write = lame_encode_buffer_interleaved (lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }

           
            fwrite (mp3_buffer, write, 1 , mp3);
           
        } while (read != 0 );
       
        lame_close (lame);
        fclose (mp3);
        fclose (pcm);
    }
    @catch (NSException *exception) {
        NSLog ( @"-------------------------------this is :%@" ,[exception description ]);
    }
    @finally {
        return mp3FilePath;
    }
}

//降噪
- ( NSString* ) noiseSuppressPath:(NSString*)pathIn pathOut:(NSString*)pathOut{
    //输出的路径
    NSString *NSpathOut = [[NSString alloc] initWithString:pathOut];
    
    VOID* ttSdkHandle = NULL;
    int ret = TT_NS_Create(&ttSdkHandle);
    if(ret == 0){
        NSLog(@"handle 创建成功");
        
        //设置参数
        struct NSParamsStruct params;
        params.fs = 32000;
        params.maxDenoisedB = -20;

        TT_NS_Init(ttSdkHandle, &params);

        NSLog(@"in路径为: %s", (char*)[pathIn UTF8String]);
        NSLog(@"out路径为: %s", (char*)[pathOut UTF8String]);
        ret = TT_NS_Process_File(ttSdkHandle, (char*)[pathIn UTF8String], (char*)[NSpathOut UTF8String]);
        if(ret == 0){
            NSLog(@"音频转换成功，路径为: %@", pathOut);
        }else{
            NSLog(@"音频转换失败，ret = %d", ret);
        }
        
    }else{
        NSLog(@"handle 创建失败, ret = %d", ret);
    }
    
    
    if(ttSdkHandle != NULL){
//        TT_NS_Free(&ttSdkHandle);
    }
    return NSpathOut;
}

//变声
- ( NSString* ) soundChangePathIn:(NSString*)pathIn pathOut:(NSString*)pathOut soundNumber:(int)number{
    NSLog(@"number:%i", number);
    
//    //输出的路径
    NSString *NSpathOut = [[NSString alloc] initWithString:pathOut];
//
    VOID* ttSdkHandle = NULL;
    //1、创建
    int ret = TT_SoundChangeCreate(&ttSdkHandle);
    if(ret == 0){
        NSLog(@"handle 创建成功");

        //2、设置结构参数
        struct SoundChangeParams params;
        params.fs = 32000;
        params.channel = 1;
        params.frameLen = 320;
        params.soundChangeMode = number;
//3、初始化
        TT_SoundChangeInit(ttSdkHandle, &params);
//4、调用方法
        NSLog(@"变声in路径为: %s", (char*)[pathIn UTF8String]);
        NSLog(@"变声out路径为: %s", (char*)[pathOut UTF8String]);
        ret = TT_SoundChangeProcessFile(ttSdkHandle, (char*)[pathIn UTF8String], (char*)[NSpathOut UTF8String]);
        if(ret == 0){
            NSLog(@"变声音频转换成功，路径为: %@", pathOut);
        }else{
            NSLog(@"变声音频转换失败，ret = %d", ret);
        }

    }else{
        NSLog(@"handle 创建失败, ret = %d", ret);
    }

    //5、清除内存
    if(ttSdkHandle != NULL){
//        TT_NS_Free(&ttSdkHandle);
    }
    return NSpathOut;
}

@end
