//
//  NovocaineController.h
//  MCDJ
//
//  Created by Stan Bershadskiy on 7/24/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridge.h"

@interface NovocaineController : NSObject<RCTBridgeModule>

-(id) init;

-(void)playSong:(NSURL *)url;
-(void)applyEQSettings:(NSNumber *)eqValue eqType:(NSString *)eqType;
@end
