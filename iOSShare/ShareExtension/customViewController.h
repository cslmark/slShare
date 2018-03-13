//
//  customViewController.h
//  ShareExtension
//
//  Created by IanChen on 2018/3/12.
//  Copyright © 2018年 IanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface customViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)closeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *urlContentView;
@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *urlDetailView;
@property (weak, nonatomic) IBOutlet UILabel *htmlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@end
