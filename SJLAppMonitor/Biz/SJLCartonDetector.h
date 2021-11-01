//
//  SJLCartonDetector.h
//  SJLCatonDetector
//
//  Created by sunjinglin on 2021/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJLCartonDetector : NSObject
+ (instancetype)sharedInstance;
- (void)startMonitorCarton:(CGFloat)cartonDuration;
- (void)startMonitorCarton:(CGFloat)cartonDuration forRunLoop:(CFRunLoopRef)runLoop;
@end

NS_ASSUME_NONNULL_END
