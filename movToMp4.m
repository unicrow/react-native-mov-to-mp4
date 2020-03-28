#import "movToMp4.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation movToMp4

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(convertMovToMp4: (NSString*)filename
                  toPath:(NSString*)outputPath
                  quality:(NSString*)quality
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSURL *ouputURL2 = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:outputPath]];
    //NSLog(@"fsdf %@", ouputURL2);
    NSString *newFile = [ouputURL2 absoluteString];
    NSURL *urlFile = [NSURL fileURLWithPath:filename];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlFile options:nil];
    
    // Video quality list
    NSDictionary* qualities = @{
        @"low": AVAssetExportPresetLowQuality,
        @"medium": AVAssetExportPresetMediumQuality,
        @"high": AVAssetExportPresetHighestQuality
    };
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:qualities[quality]];
    //AVAssetExportPresetMediumQuality
    NSString* domain = @"MovToMp4";
    exportSession.outputURL = ouputURL2;
    //set the output file format if you want to make it in other file format (ex .3gp)
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;

    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [[NSFileManager defaultManager] removeItemAtURL:filename error:nil];
        switch ([exportSession status])
        {
            case AVAssetExportSessionStatusFailed:
            {
                NSError* error = exportSession.error;
                NSString *codeWithDomain = [NSString stringWithFormat:@"E%@%zd", error.domain.uppercaseString, error.code];
                reject(codeWithDomain, error.localizedDescription, error);
                break;
            }
            case AVAssetExportSessionStatusCancelled:
            {
                NSError *error = [NSError errorWithDomain:domain code: -91 userInfo:nil];
                reject(@"Cancelled", @"Export canceled", error);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                resolve(@[newFile]);
                break;
            }
            default:
            {
                NSError *error = [NSError errorWithDomain:domain code: -91 userInfo:nil];
                reject(@"Unknown", @"Unknown status", error);
                break;
            }
        }
    }];
}


@end
