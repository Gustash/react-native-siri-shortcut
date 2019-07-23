//
//  ShortcutsModule.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "React/RCTBridgeModule.h"
#import "React/RCTConvert.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_REMAP_MODULE(RNSiriShortcuts, ShortcutsModule, RCTEventEmitter)

RCT_EXTERN_METHOD(clearAllShortcuts:(RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(clearShortcutsWithIdentifiers: (NSArray *)persistentIdentifiers resolver:(RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(donateShortcut: (NSDictionary *) options)
RCT_EXTERN_METHOD(suggestShortcuts: (NSArray<NSDictionary *> *) options)
RCT_EXTERN_METHOD(presentShortcut: (NSDictionary *) options callback: (RCTResponseSenderBlock) callback)
RCT_EXTERN_METHOD(getShortcuts:(RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject)

@end
