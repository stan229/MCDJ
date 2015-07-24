//
//  MediaController.m
//  MCDJ
//
//  Created by Stan Bershadskiy on 7/17/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MediaController.h"
#import "AppDelegate.h"


@implementation MediaController

RCT_EXPORT_MODULE();


-(void)showMediaPicker {
  MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
  
  [mediaPicker setDelegate:self];
  [mediaPicker setAllowsPickingMultipleItems:NO];
  [mediaPicker setShowsCloudItems:NO];
  mediaPicker.prompt = @"Select song";
  [[UIApplication sharedApplication].keyWindow setRootViewController:mediaPicker];
}


-(void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
  MPMediaItem *mediaItem = mediaItemCollection.items[0];
  NSURL *assetURL = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];

  
//  NSError *error;
//  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&error];
//  [self.player setDelegate:self];
//
//  if (error) {
//    NSLog(@"%@", [error localizedDescription]);
//  }
//  else{
//    // If everything is fine, just play.
//    [self.player play];
//  }
  NSData *rawData = [self getRawData:mediaItem];
  

    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:rawData fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    [self.player setDelegate:self];
  
    if (error) {
      NSLog(@"shit %@", [error description]);
    }
    else{
      // If everything is fine, just play.
      [self.player play];
    }

}

-(NSData *) getRawData:(MPMediaItem *)mediaItem {
  
  // Get raw PCM data from the track
  NSURL *assetURL = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
  NSMutableData *data = [[NSMutableData alloc] init];
  
  const uint32_t sampleRate = 16000; // 16k sample/sec
  const uint16_t bitDepth = 16; // 16 bit/sample/channel
  const uint16_t channels = 2; // 2 channel/sample (stereo)
  
  NSDictionary *opts = [NSDictionary dictionary];
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:assetURL options:opts];
  AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:NULL];
  NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                            [NSNumber numberWithFloat:(float)sampleRate], AVSampleRateKey,
                            [NSNumber numberWithInt:bitDepth], AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                            [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                            [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey, nil];
  
  AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack:        [[asset tracks] objectAtIndex:0] outputSettings:settings];

  [reader addOutput:output];
  [reader startReading];
  
  // read the samples from the asset and append them subsequently
  while ([reader status] != AVAssetReaderStatusCompleted) {
    CMSampleBufferRef buffer = [output copyNextSampleBuffer];
    if (buffer == NULL) continue;
    
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(buffer);
    size_t size = CMBlockBufferGetDataLength(blockBuffer);
    uint8_t *outBytes = malloc(size);
    CMBlockBufferCopyDataBytes(blockBuffer, 0, size, outBytes);
    CMSampleBufferInvalidate(buffer);
    CFRelease(buffer);
    [data appendBytes:outBytes length:size];
    free(outBytes);
  }
  
  return data;
}

-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [delegate switchBackToMain];
}
RCT_EXPORT_METHOD(showSongs) {
  [self showMediaPicker];
}

@end