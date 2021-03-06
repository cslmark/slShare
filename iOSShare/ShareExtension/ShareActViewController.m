//
//  ShareActViewController.m
//  ShareExtension
//
//  Created by IanChen on 2018/3/12.
//  Copyright © 2018年 IanChen. All rights reserved.
//

#import "ShareActViewController.h"

@interface ShareActViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShareActViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
}

- (void)onSelected:(void(^)(NSIndexPath *indexPath))handler
{
    self.onSelected = handler;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"所有人";
            break;
        case 1:
            cell.textLabel.text = @"好友";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onSelected)
    {
        self.onSelected (indexPath);
    }
}
@end
