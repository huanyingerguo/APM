//
//  ViewController.m
//  SJLCatonDetector
//
//  Created by sunjinglin on 2021/10/23.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark- Action

- (IBAction)testCaton:(id)sender {
    for (int i = 0; i < 1000; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self monitorHTTP];
        });
    }
}

- (void)monitorHTTP {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://img1.baidu.com/it/u=3122136587,3938996930&fm=26&fmt=auto"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"开始请求：time=%f", mach_absolute_time());
    dispatch_semaphore_t lockName_sem = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSImage *image = [[NSImage alloc] initWithData:data];
                self.imageView.image = image;
            });
        }
        NSLog(@"结束请求：time=%f", mach_absolute_time());
        dispatch_semaphore_signal(lockName_sem);
    }];
    [task resume];
    dispatch_semaphore_wait(lockName_sem, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
}

@end
