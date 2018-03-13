//
//  customViewController.m
//  ShareExtension
//
//  Created by IanChen on 2018/3/12.
//  Copyright © 2018年 IanChen. All rights reserved.
//

#import "customViewController.h"


NSString* groupSuitName = @"group.com.xjyc.sldemo";
NSString* shareUrlKey = @"share-url";
NSString* hasNewShare = @"has-new-share";
NSString* urlSuggestTitle = @"urlSuggetTitle";
NSString* shareTypeKey = @"shareTypeKey";
NSString* shareTypePublicKey = @"shareTypePublicKey";

@interface customViewController ()
@property (nonatomic, strong) NSMutableArray* funcList;
@property (nonatomic, strong) NSMutableArray* menuList;
@end

@implementation customViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //获取分享链接
    __block BOOL hasGetUrl = NO;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.attachments enumerateObjectsUsingBlock:^(NSItemProvider *  _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"obj.attributedTitle = %@", obj.attributedTitle);
            NSLog(@"obj.attributedContentText = %@", obj.attributedContentText);
            NSLog(@"obj.userInfo = %@", obj.userInfo);
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"])
            {
                [itemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    if ([(NSObject *)item isKindOfClass:[NSURL class]])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //((NSURL *)item).absoluteString
                            self.urlContentView.hidden = NO;
                            self.urlDetailView.attributedText = obj.attributedContentText;
                            self.htmlLabel.text = ((NSURL *)item).absoluteString;
                            
                            NSData* imageData = obj.userInfo[@"NSExtensionItemAttributedContentTextKey"];
                            self.urlImageView.image = [UIImage imageWithData:imageData];
                            self.urlImageView.backgroundColor = [UIColor blueColor];
                            
                            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupSuitName];
                            [userDefaults setValue: ((NSURL *)item).absoluteString forKey:shareUrlKey];
                            [userDefaults setValue:obj.attributedContentText.string forKey:urlSuggestTitle];
                            [userDefaults setValue:@"public.url" forKey:shareTypePublicKey];
                            //用于标记是新的分享
                            [userDefaults setBool:YES forKey:hasNewShare];
                            
                        });
                    }
                }];
                
                hasGetUrl = YES;
                *stop = YES;
            }else{             //如果是图片的话，处理方式
                [itemProvider loadItemForTypeIdentifier:@"public.image" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    if ([(NSObject *)item isKindOfClass:[NSURL class]])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString* filePath = ((NSURL *)item).absoluteString;
                            NSURL* url = [NSURL URLWithString:filePath];
                            NSData* imageData = [NSData dataWithContentsOfURL:url];
                            UIImage* image = [UIImage imageWithData:imageData];
                            self.picView.image = image;
                            //((NSURL *)item).absoluteString
                            self.urlContentView.hidden = YES;
                            self.urlDetailView.attributedText = obj.attributedContentText;
                            self.htmlLabel.text = ((NSURL *)item).absoluteString;
                            
                            
                            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupSuitName];
                            [userDefaults setValue: ((NSURL *)item).absoluteString forKey:shareUrlKey];
                            [userDefaults setValue:obj.attributedContentText.string forKey:urlSuggestTitle];
                            [userDefaults setValue:@"public.image" forKey:shareTypePublicKey];
                            //用于标记是新的分享
                            [userDefaults setBool:YES forKey:hasNewShare];
                            
                        });
                    }
                }];
                
                hasGetUrl = YES;
                *stop = YES;
                
            }
            *stop = hasGetUrl;
        }];
    }];
}

#pragma mark - 懒加载部分
-(NSMutableArray *)funcList{
    if (_funcList == nil) {
        _funcList = [NSMutableArray arrayWithCapacity:3];
        NSArray* itemArray = @[@"发送给朋友", @"分享到朋友圈", @"收藏"];
        for(int i = 0; i < 3; i++){
            SLComposeSheetConfigurationItem* item = [[SLComposeSheetConfigurationItem alloc] init];
            item.title = itemArray[i];
            item.value = @"请选择";
            item.tapHandler = nil;
            [_funcList addObject:item];
        }
    }
    return _funcList;
}

-(NSMutableArray *) menuList{
    if (_menuList == nil) {
        _menuList = [NSMutableArray arrayWithCapacity:1];
        NSArray* typeArray = @[@"friends", @"friendCicle", @"collection"];
        [_menuList addObjectsFromArray:typeArray];
    }
    return _menuList;
}



- (void)cancelBtnClickHandler:(id)sender
{
    //取消分享
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"CustomShareError" code:NSUserCancelledError userInfo:nil]];
}

- (void)postBtnClickHandler:(id)sender
{
    //执行分享内容处理
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

#pragma mark - 按键的处理
- (IBAction)closeClick:(UIButton *)sender {
    [self cancelBtnClickHandler:nil];
}

#pragma mark - tableView部分的数据源和代理方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funcList.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    SLComposeSheetConfigurationItem* item = self.funcList[indexPath.row];
    cell.textLabel.text = item.title;
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择了   indexPath  = %@", indexPath);
    //发送把阴影去掉
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //把对应的链接传递给对应的页面
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupSuitName];
    NSString* type = self.menuList[indexPath.row];
    [userDefaults setValue:type forKey:shareTypeKey];
    //调用完成的方法
    [self postBtnClickHandler:nil];
}
@end

/*
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <string>MainInterface</string>
 </plist>
 */
