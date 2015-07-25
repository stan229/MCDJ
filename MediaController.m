//
//  MediaController.m
//  MCDJ
//
//  Created by Stan Bershadskiy on 7/17/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MediaController.h"
#import "AppDelegate.h"

#import "NovocaineController.h"

@implementation MediaController

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;


-(void)showMediaPicker {
  if(self.mediaPicker == nil) {
    self.mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    [self.mediaPicker setDelegate:self];
    [self.mediaPicker setAllowsPickingMultipleItems:NO];
    [self.mediaPicker setShowsCloudItems:NO];
    self.mediaPicker.prompt = @"Select song";
  }
  
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [delegate.rootViewController presentViewController:self.mediaPicker animated:YES completion:nil];
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
//  NSData *rawData = [self getRawData:mediaItem];
  

//    NSError *error;
//    self.player = [[AVAudioPlayer alloc] initWithData:rawData fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
//    [self.player setDelegate:self];
//  
//    if (error) {
//      NSLog(@"shit %@", [error description]);
//    }
//    else{
//      // If everything is fine, just play.
//      [self.player play];
//    }

  [self.bridge.eventDispatcher sendAppEventWithName:@"SongPlaying" body:[mediaItem valueForProperty:MPMediaItemPropertyTitle]];
  
  [[[NovocaineController alloc] init] playSong:assetURL];
}


-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [delegate.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
RCT_EXPORT_METHOD(showSongs) {
  [self showMediaPicker];
}


@end