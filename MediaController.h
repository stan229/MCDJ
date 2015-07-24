//
//  MediaController.h
//  MCDJ
//
//  Created by Stan Bershadskiy on 7/17/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridge.h"

#import <MediaPlayer/MediaPlayer.h>
@import AVFoundation;
@interface MediaController : NSObject<RCTBridgeModule,MPMediaPickerControllerDelegate, AVAudioPlayerDelegate>
@property (nonatomic, retain) AVAudioPlayer *player;

- (void) showMediaPicker;
- (NSData *) getRawData:(MPMediaItem *)mediaItem;
@end