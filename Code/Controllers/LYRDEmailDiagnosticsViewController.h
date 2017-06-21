//
//  LYRDEmailDiagnosticsViewController.h
//  LayerKitDiagnostics
//
//  Created by Daniel Maness on 8/26/16.
//  Copyright © 2016 Layer, Inc. All rights reserved.
//

#import <LayerKit/LYRClient.h>
#import <MessageUI/MFMailComposeViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYRDEmailDiagnosticsViewController : MFMailComposeViewController

/**
 @abstract Creates and returns a new `LYREmailDiagnosticsViewController` initialized with an `LYRClient` object.
 @param layerClient The `LYRClient` object from which to retrieve the messages for display.
 @return An `LYREmailDiagnosticsViewController` object.
 */
- (instancetype)initWithLayerClient:(LYRClient *)layerClient withCcRecipients:(nullable NSArray<NSString *> *)ccRecipients;

/**
 @abstract Captures a snapshot of the current application state and creates an email containing all data.  Includes logs, 
    plist file, current database, current screenshot, and relevant app and device data.
 @discussion This creates the email, but the `LYREmailDiagnosticsViewController` must still be presented in order to send.
 @param completion An optional block to be executed once the snapshot has been captured. The block has no return value and 
    accepts two arguments: a Boolean value indicating if the snapshot was created successfully and an error object that, 
    upon failure, indicates the reason the snapshot was unsuccessful.
 */
- (void)captureDiagnosticsWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 @abstract The `LYRClient` object used to initialize the controller.
 @discussion If using storyboards, the property must be set explicitly.
 @raises NSInternalInconsistencyException Raised if the value is mutated after the receiver has been presented.
 */
@property (nonatomic) LYRClient *layerClient;

@end

NS_ASSUME_NONNULL_END
