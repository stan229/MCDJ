//
//  NovocaineController.m
//  MCDJ
//
//  Created by Stan Bershadskiy on 7/24/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "NovocaineController.h"
#import "Novocaine.h"
#import "AudioFileReader.h"

@interface NovocaineController ()

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;

@end

@implementation NovocaineController

-(void)playSong:(NSURL *)url {
  self.audioManager = [Novocaine audioManager];
  [self.audioManager setForceOutputToSpeaker:YES];
  self.fileReader = [[AudioFileReader alloc] initWithAudioFileURL:url samplingRate:self.audioManager.samplingRate numChannels:self.audioManager.numOutputChannels];
  
  [self.fileReader play];
  __weak NovocaineController *wself = self;
  
  
  [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];

   }];
  [self.audioManager play];
  
}

@end
