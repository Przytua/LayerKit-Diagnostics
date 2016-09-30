//
//  LYRDEmailDiagnosticsViewController.m
//  LayerKitDiagnostics
//
//  Created by Daniel Maness on 8/26/16.
//  Copyright © 2016 Layer, Inc. All rights reserved.
//

#import "LYRDEmailDiagnosticsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

extern NSString *const LYRSDKVersionString;
extern NSString *LYRHTTPUserAgentString();

@implementation LYRDEmailDiagnosticsViewController

NSString *const LYRDSupportEmailAddress = @"support@layer.com";
NSString *const LYRDEmailSubject = @"LayerKit iOS Debug Support";
NSString *const LYRDDateFormat = @"dd/MM/yy HH:mm:ss";
NSString *const LYRDSnapshotMIMEType = @"application/zip";
NSString *const LYRDSnapshotFileName = @"layer-debug-snapshot.zip";
NSString *const LYRDScreenshotMIMEType = @"image/png";
NSString *const LYRDScreenshotFileName = @"screenshot.png";

- (instancetype)initWithLayerClient:(LYRClient *)layerClient withCcRecipients:(nullable NSArray<NSString *> *)ccRecipients
{
    NSAssert(layerClient, @"Layer Client cannot be nil");
    self = [super init];
    if (self)  {
        _layerClient = layerClient;
        
        // Basic email data
        [self setToRecipients:[NSArray arrayWithObject:LYRDSupportEmailAddress]];
        [self setCcRecipients:ccRecipients];
        [self setSubject:LYRDEmailSubject];
    }
    return self;
}

- (void)captureDiagnosticsWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    // Layer client will build the Zip file and return the file path
    [_layerClient captureDebugSnapshotWithCompletion:^(NSURL * _Nullable snapshotPath, NSError * _Nullable error) {
        if (snapshotPath) {
            // Formatted message body
            NSString *messageBody = [self createMessageBody];
            [self setMessageBody:messageBody isHTML:NO];
            
            // Screenshot of current display
            NSData *screenshotFile = UIImagePNGRepresentation([self captureCurrentScreenshot]);
            [self addAttachmentData:screenshotFile mimeType:LYRDScreenshotMIMEType fileName:LYRDScreenshotFileName];
            
            // Zip file containing logs and database
            NSData *zipFile = [NSData dataWithContentsOfURL:snapshotPath];
            [self addAttachmentData:zipFile mimeType:LYRDSnapshotMIMEType fileName:LYRDSnapshotFileName];
            
            completion(YES, nil);
        } else {
            completion(NO, error);
        }

    }];
}

- (NSString *)createMessageBody
{
    NSString *text =   @"If you have emailed our support about this issue already, please include the ticket ID you were assigned.\n"
                        "Otherwise, provide steps to reproduce and more details about the issue.\n"
                        "Without these, we will not have enough information to investigate and will close the ticket.\n"
                        "\n"
                        "Description of the issue: \n"
                        "Steps to reproduce: \n"
                        "1. \n"
                        "2. \n"
                        "3. \n"
                        "Related support ticket IDs: \n"
                        "More details: \n"
                        "\n"
                        "## Log Info\n"
                        "* App ID: %@\n"
                        "* Time: %@\n"
                        "* Platform: %@\n"
                        "* Device: %@\n"
                        "* SDK: %@\n"
                        "* Layer User ID: %@\n"
                        "* User Agent: %@\n";
    
    NSString *appID = _layerClient.appID.absoluteString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:LYRDDateFormat];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *platform = [UIDevice currentDevice].systemVersion;
    NSString *device = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *sdk = LYRSDKVersionString;
    NSString *authenticatedUserID = _layerClient.authenticatedUser.userID;
    NSString *userAgent = LYRHTTPUserAgentString();
    
    NSString *messageBody = [NSString stringWithFormat:text, appID, time, platform, device, sdk, authenticatedUserID, userAgent];

    return messageBody;
}

- (UIImage *)captureCurrentScreenshot
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext([keyWindow bounds].size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
