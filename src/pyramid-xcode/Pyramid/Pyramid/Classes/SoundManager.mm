//
//  SoundManager.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 17/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//
// http://benbritten.com/2008/11/06/openal-sound-on-the-iphone/

#import "SoundManager.h"

@implementation SoundManager

+ (SoundManager *)instance {
    static SoundManager *c = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        c = [[self alloc] init];
    });
    return c;
}

- (void) playVictorySound {
    [self changeVolume:@"victory" volume:0.3];
    [self playSound:@"victory"];
}

- (void) playGameOverSound {
    [self changeVolume:@"gameover" volume:0.3];
    [self playSound:@"gameover"];
}

- (void) playBallInsideSound {
    [self changeVolume:@"ball-fallen-inside" volume:0.3];
    [self playSound:@"ball-fallen-inside"];
}

- (void) playCollisionSound:(int)sphereIndex withVolume:(float)volume {
    [self changeVolume:[NSString stringWithFormat:@"collision%d", sphereIndex] volume:volume];
    [self playSound:[NSString stringWithFormat:@"collision%d", sphereIndex]];
}

- (void) playRollingSphereSound:(int)sphereIndex {
    [self playSound:[NSString stringWithFormat:@"ball%d", sphereIndex]];
}

- (void) stopRollingSphereSound:(int)sphereIndex {
    [self stopSound:[NSString stringWithFormat:@"ball%d", sphereIndex]];
    [self changeVolume:[NSString stringWithFormat:@"ball%d", sphereIndex] volume:0.0];
}

- (void) changeRollingSphereVelocity:(int)sphereIndex velocity:(float)velocity {
    [self changeVelocity:[NSString stringWithFormat:@"ball%d", sphereIndex] velocity:velocity];
}

- (id) init {
    self = [super init];
    [self initOpenAL];
    return self;
}

- (void) loadSound:(NSString*)key pathForResource:(NSString*)pathForResource ofType:(NSString*)ofType loop:(BOOL)loop {
    // get the full path of the file
    NSString* fileName = [[NSBundle mainBundle] pathForResource:pathForResource ofType:ofType];
    // first, open the file
    AudioFileID fileID = [self openAudioFile:fileName];
    
    // find out how big the actual audio data is
    UInt32 fileSize = [self audioFileSize:fileID];
    
    // this is where the audio data will live for the moment
    unsigned char * outData = (unsigned char *)malloc(fileSize);
    
    // this where we actually get the bytes from the file and put them
    // into the data buffer
    OSStatus result = noErr;
    result = AudioFileReadBytes(fileID, false, 0, &fileSize, outData);
    AudioFileClose(fileID); //close the file
    
    if (result != 0) NSLog(@"cannot load effect: %@",fileName);
    
    NSUInteger bufferID;
    // grab a buffer ID from openAL
    alGenBuffers(1, &bufferID);
	
    // jam the audio data into the new buffer
    alBufferData(bufferID,AL_FORMAT_STEREO16,outData,fileSize,44100);
    
    // save the buffer so I can release it later
    [bufferStorageArray addObject:[NSNumber numberWithUnsignedInteger:bufferID]];
    
    NSUInteger sourceID;
    
    // grab a source ID from openAL
    alGenSources(1, &sourceID);
    
    // attach the buffer to the source
    alSourcei(sourceID, AL_BUFFER, bufferID);
    // set some basic source prefs
    alSourcef(sourceID, AL_PITCH, 1.0f);
    alSourcef(sourceID, AL_GAIN, 0.0);
    
    if (loop) alSourcei(sourceID, AL_LOOPING, AL_TRUE);
    
    // store this for future use
    [soundDictionary setObject:[NSNumber numberWithUnsignedInt:sourceID] forKey:key];
    
    // clean up the buffer
    if (outData)
    {
        free(outData);
        outData = NULL;
    }
}

- (void) initOpenAL {
	device = alcOpenDevice(NULL); // select the "preferred device"
	if (device) {
		// use the device to make a context
		context=alcCreateContext(device,NULL);
		// set my context to the currently active one
		alcMakeContextCurrent(context);
	}
    bufferStorageArray = [[NSMutableArray alloc] init];
    soundDictionary = [[NSMutableDictionary alloc] init];
//    [self loadSound:@"ball0" pathForResource:@"ball" ofType:@"caf" loop:true];
//    [self loadSound:@"ball1" pathForResource:@"ball" ofType:@"caf" loop:true];
//    [self loadSound:@"ball2" pathForResource:@"ball" ofType:@"caf" loop:true];
//    [self loadSound:@"collision0" pathForResource:@"collision" ofType:@"caf" loop:false];
//    [self loadSound:@"collision1" pathForResource:@"collision" ofType:@"caf" loop:false];
//    [self loadSound:@"collision2" pathForResource:@"collision" ofType:@"caf" loop:false];
//    [self loadSound:@"gameover" pathForResource:@"gameover" ofType:@"caf" loop:false];
//    [self loadSound:@"ball-fallen-inside" pathForResource:@"ball-fallen-inside" ofType:@"caf" loop:false];
//    [self loadSound:@"victory" pathForResource:@"victory" ofType:@"caf" loop:false];
}

// open the audio file
// returns a big audio ID struct
- (AudioFileID) openAudioFile:(NSString*)filePath {
	AudioFileID outAFID;
	// use the NSURl instead of a cfurlref cuz it is easier
	NSURL * afUrl = [NSURL fileURLWithPath:filePath];
	
	// do some platform specific stuff..
#if TARGET_OS_IPHONE
	OSStatus result = AudioFileOpenURL((CFURLRef)CFBridgingRetain(afUrl), kAudioFileReadPermission, 0, &outAFID);
#else
	OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, fsRdPerm, 0, &outAFID);
#endif

	if (result != 0) NSLog(@"cannot openf file: %@",filePath);
	return outAFID;
}


- (BOOL) isSoundPlaying:(NSString*)soundKey {
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil) return false;
	NSUInteger sourceID = [numVal unsignedIntValue];
    ALenum state;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &state);
    return (state == AL_PLAYING);
}

// find the audio portion of the file
// return the size in bytes
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor {
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
	if(result != 0) NSLog(@"cannot find file size");
	return (UInt32)outDataSize;
}

- (void) changeVolume:(NSString *) soundKey volume:(ALfloat)volume {
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
    alSourcef(sourceID, AL_GAIN, volume);
    
}

- (void) changeVelocity:(NSString *) soundKey velocity:(ALfloat)velocity {
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
    alSourcef(sourceID, AL_PITCH, MIN(1.0, velocity/0.3)/2+0.5);
    alSourcef(sourceID, AL_GAIN, velocity*velocity);

}

// the main method: grab the sound ID from the library
// and start the source playing
- (void)playSound:(NSString*)soundKey {
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil || [self isSoundPlaying:soundKey]) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
	alSourcePlay(sourceID);
}

- (void)stopSound:(NSString*)soundKey {
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
	alSourceStop(sourceID);
}

-(void)cleanUpOpenAL:(id)sender {
	// delete the sources
	for (NSNumber * sourceNumber in [soundDictionary allValues]) {
		NSUInteger sourceID = [sourceNumber unsignedIntegerValue];
		alDeleteSources(1, &sourceID);
	}
	[soundDictionary removeAllObjects];
	
	// delete the buffers
	for (NSNumber * bufferNumber in bufferStorageArray) {
		NSUInteger bufferID = [bufferNumber unsignedIntegerValue];
		alDeleteBuffers(1, &bufferID);
	}
	[bufferStorageArray removeAllObjects];
	
	// destroy the context
	alcDestroyContext(context);
	// close the device
	alcCloseDevice(device);
}

@end
