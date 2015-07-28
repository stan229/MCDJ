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

#import "NVDSP.h"
#import "NVPeakingEQFilter.h"
#import "NVSoundLevelMeter.h"

@interface NovocaineController ()

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;

-(NVPeakingEQFilter *)getFilterByEQType:(NSString *)eqType;

@end

@implementation NovocaineController {
  float initialGain;
  float frequencyBands[3];
  NVPeakingEQFilter *PEQ[3];
}

RCT_EXPORT_MODULE();

-(id) init {
  self = [super init];
  if(self) {
    self.audioManager = [Novocaine audioManager];
    
    initialGain = 0.0f;
    
    frequencyBands[0] = 40.0f;
    frequencyBands[1] = 500.0f;
    frequencyBands[2] = 12000.0f;
    
    
    for(int i = 0; i < 3; i++) {
      NVPeakingEQFilter *peq = [[NVPeakingEQFilter alloc] initWithSamplingRate:self.audioManager.samplingRate];
      peq.Q = 2.0f;
      peq.centerFrequency = frequencyBands[i];
      peq.G = initialGain;
      
      PEQ[i] = peq;
    }
    
  }
  return self;
}

-(void)playSong:(NSURL *)url {
  
  [self.audioManager setForceOutputToSpeaker:YES];
  self.fileReader = [[AudioFileReader alloc] initWithAudioFileURL:url samplingRate:self.audioManager.samplingRate numChannels:self.audioManager.numOutputChannels];
  
  [self.fileReader play];
  __weak NovocaineController *wself = self;
  
  [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
   {
     [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
     
     for(int i = 0; i < 3; i++) {
       [PEQ[i] filterData:data numFrames:numFrames numChannels:numChannels];
     }
     
   }];
  [self.audioManager play];
  
}

-(NVPeakingEQFilter *) getFilterByEQType:(NSString *)eqType {
  int arrayPos;

  if([eqType isEqualToString:@"low"]) {
    arrayPos = 0;
  } else if ([eqType isEqualToString:@"mid"]) {
    arrayPos = 1;
  } else if([eqType isEqualToString:@"high"]) {
    arrayPos = 2;
  }
  
  return PEQ[arrayPos];
}


-(void) applyEQSettings:(NSNumber *)eqValue eqType:(NSString *)eqType {
  NVPeakingEQFilter *peq = [self getFilterByEQType:eqType];
  peq.G = [eqValue floatValue];
}


@end
