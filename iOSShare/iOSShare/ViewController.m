//
//  ViewController.m
//  iOSShare
//
//  Created by IanChen on 2018/3/12.
//  Copyright © 2018年 IanChen. All rights reserved.
//

#import "ViewController.h"
#import <Social/social.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareClick:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView.image = [UIImage imageNamed:@"baidubg.jpg"];
    
    //初始化一个供App Groups使用的NSUserDefaults对象
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.vimfung.ShareExtensionDemo"];
    
    //写入数据
    [userDefaults setValue:@"value" forKey:@"key"];
    
    //读取数据
    NSLog(@"%@", [userDefaults valueForKey:@"key"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 returnedItems是一个包含NSExtensionItem对象的数组；activityError指出出错原因
 当我们分享成功或者分项取消的时候，都活调用block函数
 activityType：是分享到什么平台，如果是系统的平台，会打印系统枚举类中的名字，微信等三方平台会打印com.tencent.xin.sharetimeline
 成功后completed为YES否则为NO。我们在成功后或者失败后调用我们需要执行的代码
 */
- (IBAction)shareClick:(UIButton *)sender {
    NSArray* images = @[self.imageView.image];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:images applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];

    activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"用户选择了  returnedItems = %@", returnedItems);  //一般返回的都是null
        NSLog(@"activityType = %@", activityType);
        if (completed) {
            NSLog(@"用户完成了分享");
        }else{
            NSLog(@"用户取消了分享");
        }
    };
    [self.navigationController presentViewController:activityController animated:YES completion:^{
        NSLog(@"完成了。。。。。。。。。。。。。。。。。。。。");
    }];
}
@end
