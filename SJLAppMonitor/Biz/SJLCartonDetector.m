//
//  SJLCartonDetector.m
//  SJLCatonDetector
//
//  Created by sunjinglin on 2021/10/23.
//

#import "SJLCartonDetector.h"
#import "CommonDefine.h"
#import "BSBacktraceLogger.h"

static const NSTimeInterval kRunLoopThreshold = 0.3;
static uint64_t kStartTime = 0;
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
  switch (activity) {
    case kCFRunLoopEntry:
            break;
    case kCFRunLoopBeforeTimers:
            break;
    case kCFRunLoopBeforeSources: //准备处理业务
          break;
    case kCFRunLoopAfterWaiting: //唤醒之后，开始工作
        kStartTime = mach_absolute_time();
        break;
    case kCFRunLoopBeforeWaiting:
        if (kStartTime != 0 ) {
            uint64_t elapsed = mach_absolute_time() - kStartTime;
            
            mach_timebase_info_data_t timebase;
            mach_timebase_info(&timebase);
            NSTimeInterval duration = elapsed * timebase.numer / timebase.denom / 1e9;
            
            if (duration > kRunLoopThreshold) {
                NSString *trace = [BSBacktraceLogger bs_backtraceOfAllThread];
                NSLog(@"卡顿发生: duraion=%f, tarace=%@", duration, trace);
            }
        }
        break;
    case kCFRunLoopExit:
        break;
    default:
        break;
    }
}

@interface SJLCartonDetector ()
{
    CFRunLoopObserverRef observer;
    CFRunLoopRef observeredRunLoop;
}
@property (assign) CGFloat cartonDuration;
@end

@implementation SJLCartonDetector

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static SJLCartonDetector *sharedDetector;
    dispatch_once(&once, ^{
        sharedDetector = [[SJLCartonDetector alloc] init];
    });
    
    return sharedDetector;
}

- (void)startMonitorCarton:(CGFloat)cartonDuration {
    [self startMonitorCarton:cartonDuration forRunLoop:CFRunLoopGetMain()];
}

- (void)startMonitorCarton:(CGFloat)cartonDuration forRunLoop:(CFRunLoopRef)runLoop {
    self.cartonDuration = cartonDuration;
    [self unRunMonitor];
    [self runMonitorforRunLoop:runLoop];
}

- (void)runMonitorforRunLoop:(CFRunLoopRef)runLoop {
    CFRunLoopObserverContext context = {0,
        (__bridge  void *)self,
        NULL,
        NULL,
        NULL
    };
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &runLoopObserverCallBack,
                                                            &context);
    
    if (!runLoop) {
        runLoop = CFRunLoopGetMain();
    }
    
    observeredRunLoop = runLoop;
    observer = observer;
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
}

- (void)unRunMonitor {
    if (observeredRunLoop &&
        observer) {
        CFRunLoopRemoveObserver(observeredRunLoop, observer, kCFRunLoopCommonModes);
        observer = nil;
        observeredRunLoop = nil;
    }
}

@end
