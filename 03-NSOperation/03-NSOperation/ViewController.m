//
//  ViewController.m
//  03-NSOperation
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

#define kImgURLStr  @"http://d.hiphotos.baidu.com/image/pic/item/472309f79052982249530eecd6ca7bcb0a46d4b8.jpg"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)fetchImage:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"主线程!");
        _imageView.image = image;
    } else {
        NSLog(@"对等线程!");
        [_imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    }
}

- (IBAction)loadImage:(id)sender {
    
    NSURL *url = [NSURL URLWithString:kImgURLStr];
    // 1. 创建一个操作
//    NSOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchImage:) object:url];
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self fetchImage:url];
    }];
    
    // 2. 创建一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 3. 添加一个操作(此时，线程就执行了)
    [queue addOperation:op];
//    [[NSOperationQueue mainQueue] addOperation:op];
}


@end
