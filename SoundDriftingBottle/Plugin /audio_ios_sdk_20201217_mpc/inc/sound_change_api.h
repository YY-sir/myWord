#ifndef SOUND_CHANGE_API_H_
#define SOUND_CHANGE_API_H_

#include "audio_common.h"

#ifdef __cplusplus
extern "C" {
#endif


#define TT_SOUND_CHANGE_ERR_OK                  0
#define TT_SOUND_CHANGE_ERR_VERSION_NULL       -1
#define TT_SOUND_CHANGE_ERR_VERSION_LENGTH     -2
#define TT_SOUND_CHANGE_ERR_HANDLE             -3
#define TT_SOUND_CHANGE_ERR_PARAMS             -4
#define TT_SOUND_CHANGE_ERR_FS                 -5
#define TT_SOUND_CHANGE_ERR_CHANNEL            -6
#define TT_SOUND_CHANGE_ERR_FRAMELEN           -7
#define TT_SOUND_CHANGE_ERR_MODE               -8
#define TT_SOUND_CHANGE_ERR_NOT_INIT           -9
#define TT_SOUND_CHANGE_ERR_PCMIN              -10
#define TT_SOUND_CHANGE_ERR_PCMOUT             -11
#define TT_SOUND_CHANGE_ERR_INPUT_FILE         -12
#define TT_SOUND_CHANGE_ERR_OUTPUT_FILE        -13
#define TT_SOUND_CHANGE_ERR_PROCESS_FILE       -14
#define TT_SOUND_CHANGE_ERR_GETSAMPLERATIO     -15
#define TT_SOUND_CHANGE_ERR_INVALID            -16

#define TT_SOUND_CHANGE_ERR_SOUNDTOUCH         -100  // -100~-199  Soundtouch
#define TT_SOUND_CHANGE_ERR_VIBRATE            -200  // -200~-299  Vibrate
#define TT_SOUND_CHANGE_ERR_ECHO               -300  // -300~-399  Echo

// 0 yuansheng
// 1 luoli
// 2 shaonv
// 3 dashu
// 4 moshou
// 5 gaoguai  (biansu)
// 6 wanghongnv  (biansu)
// 7 jingsong
// 8 kongling
typedef enum enSoundChangeMode
{
    SOUND_CHANGE_MODE_ORIGINAL = 0,
    SOUND_CHANGE_MODE_LOLI = 1,
    SOUND_CHANGE_MODE_GIRL = 2,
    SOUND_CHANGE_MODE_UNCLE = 3,
    SOUND_CHANGE_MODE_WARCRAFT = 4,
    SOUND_CHANGE_MODE_SPOOF = 5,
    SOUND_CHANGE_MODE_WOMAN = 6,
    SOUND_CHANGE_MODE_HORROR = 7,
    SOUND_CHANGE_MODE_ETHEREAL = 8,
    SOUND_CHANGE_MODE_NULL = 9
}SoundChangeMode;

#define SOUND_CHANGE_FRAMELEN_MAX 320
// when init modules, use this struct of params including all params.
// sampleRate is 32000, channel is 1, frameLen is 320 by default
typedef struct SoundChangeParams
{
    INT32 fs;
    INT32 channel;
    INT32 frameLen;
    INT32 soundChangeMode;
}stSoundChangeParams;

extern const stSoundChangeParams TTSoundChangeParamsDefault;
//*****************************************************************************
// Function: Returns the version number of the code.
//
// Input:
//       - version: Pointer to a character array where the version info is stored.
//       - length : Length of version. The RECOMMENDED byte-length is not less than 40.
//
// Return value:   0 - OK
//                 -1 - Error (probably length is not sufficient)
//*****************************************************************************
extern INT32 TT_SoundChangeGetVersion(INT8 *versionStr, INT32 length);


//*****************************************************************************
//  Function: Creates an instance to the sound change structure.
//
// Input:
//      -  SCInst: Pointer to sound change instance that should be created.
//
// Output:
//      -  SCInst: Pointer to sound change instance that created.
//
// Return value:  0 - OK
//                others - Error
//*****************************************************************************
extern INT32 TT_SoundChangeCreate(VOID **SCInst);


//*****************************************************************************
//  Function: Init an instance to the sound change structure.
//
// Input:
//      -  SCInst: Pointer to sound change instance that should be initialized.
//
// Output:
//      -  SCInst: initialized sound change instance.
//      -  stSoundChangeParams: params that will be used to init the instance.
//
// Return value:  0 - OK
//                others - Error
//*****************************************************************************
extern INT32 TT_SoundChangeInit(VOID *SCInst, stSoundChangeParams *pstParams);


//*****************************************************************************
// Function: Do sound change for input speech file.
//
// Input
//      - SCInst: sound change Instance. Needs to be initiated before call.
//      - PCMFileIn : input PCM file.
//
// Output:
//      - SCInst: Updated sound change instance
//      - PCMFileOut: PCM file after sound change.
//
// Return value:  0 - OK
//               others - Error
//*****************************************************************************
 extern INT32 TT_SoundChangeProcessFile(VOID *SCInst, INT8 *PCMFileIn, INT8 *PCMFileOut);


//*****************************************************************************
// Function: Do sound change for input audio frame by frame.
//
// ATTENTION: the length of one frame should be 10ms, that is 320 points for 32kHz.
//
// Input
//      - SCInst: sound change Instance. Needs to be initiated before call.
//      - PCMIn   : input PCM samples
//      - inSampleNum: input sample numbers <-deleted, that is frameLen
//
// Output:
//      - SCInst: Updated sound change instance
//      - PCMOut: PCM samples after sound change process.
//      - outSampleNum: output sample numbers pointer
//
// Return value:  0 - OK
//                others - Error
//*****************************************************************************
extern INT32 TT_SoundChangeProcessFrame(VOID *SCInst, INT16 *PCMIn,
                                                     INT16 *PCMOut, INT32 *outSampleNum);


//*****************************************************************************
// Function: Flush left samples. When use ProcessFrame() intereface, we should flush the left sample
//                 in the channel before end the process.
//
// Input
//      - SCInst: sound change Instance. Needs to be initiated before call.
//
// Output:
//      - SCInst: Updated sound change instance
//      - PCMOut: PCM samples after sound change process.
//      - outSampleNum: output sample numbers pointer
//
// Return value:  0 - OK
//                others - Error
//*****************************************************************************
extern INT32 TT_SoundChangeFlush(VOID *SCInst, INT16 *PCMOut, INT32 *outSampleNum);


//*****************************************************************************
// Function: Get length ratio of input file to output file. If the sound change is not related to rate
//                 change, the sampleRatio is 1.0f.
//
// Input
//      - SCInst: sound change Instance. Needs to be initiated before call.
//
// Output:
//      - sampleRatio: length ratio of input file to output file pointer.
//
// Return value:  0 - OK
//                others - Error
//*****************************************************************************
extern INT32 TT_SoundChangeGetSampleRatio(VOID *SCInst, Float32 *sampleRatio);


//*****************************************************************************
// Function: Frees the dynamic memory of a specified sound change instance.
//
// Input:
//      - SCInst: Pointer to sound change instance that should be freed.
//
// Return value:  0 - OK
//               others - Error
//*****************************************************************************
extern INT32 TT_SoundChangeFree(VOID *SCInst);


#ifdef __cplusplus
}
#endif

#endif

