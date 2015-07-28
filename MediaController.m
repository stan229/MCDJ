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
  
  [self.bridge.eventDispatcher sendAppEventWithName:@"SongPlaying" body:[mediaItem valueForProperty:MPMediaItemPropertyTitle]];
  if(self.novocaine == nil) {
    self.novocaine = [[NovocaineController alloc] init];
  }
  
  [self.novocaine playSong:assetURL];
  hideMediaPicker();
  
}


-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  hideMediaPicker();
}

#pragma mark RCT_EXPORT
RCT_EXPORT_METHOD(showSongs) {
  [self showMediaPicker];
}

RCT_EXPORT_METHOD(applyEQ:(NSNumber *)eqValue eqType:(NSString *) eqType) {
  [self.novocaine applyEQSettings:eqValue eqType:eqType];
}





#pragma mark private-methods
void hideMediaPicker() {
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [delegate.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
@end