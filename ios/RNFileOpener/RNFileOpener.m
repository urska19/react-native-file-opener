#import "RNFileOpener.h"

@implementation FileOpener

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(open, filePath:(NSString *)filePath fileMine:(NSString *)fileMine
                iPadPositionX:(nonnull NSNumber *)iPadPositionX iPadPositionY:(nonnull NSNumber *)iPadPositionY 
                iPadPositionWidth:(nonnull NSNumber *)iPadPositionWidth iPadPositionHeight:(nonnull NSNumber *)iPadPositionHeight
                resolver:(RCTPromiseResolveBlock)resolve
                rejecter:(RCTPromiseRejectBlock)reject)
{
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fileURL.path]) {
        NSError *error = [NSError errorWithDomain:@"File not found" code:404 userInfo:nil];
        reject(@"File not found", @"File not found", error);
        return;
    }
    
    self.FileOpener = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.FileOpener.delegate = self;
    
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    BOOL wasOpened = [self.FileOpener presentOpenInMenuFromRect:ctrl.view.bounds inView:ctrl.view animated:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect iPadRect = CGRectMake([iPadPositionX floatValue], [iPadPositionY floatValue], [iPadPositionWidth floatValue], [iPadPositionHeight floatValue]);
        wasOpened = [self.FileOpener presentOptionsMenuFromRect:iPadRect inView:ctrl.view animated:YES];
    }
    
    if (wasOpened) {
        resolve(@"Open success!!");
    } else {
        NSError *error = [NSError errorWithDomain:@"Open error" code:500 userInfo:nil];
        reject(@"Open error", @"Open error", error);
    }
    
}

@end