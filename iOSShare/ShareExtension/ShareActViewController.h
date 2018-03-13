//
//  ShareActViewController.h
//  ShareExtension
//
//  Created by IanChen on 2018/3/12.
//  Copyright © 2018年 IanChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedHandler)(NSIndexPath *indexPath);
@interface ShareActViewController : UIViewController
@property (nonatomic, copy) selectedHandler onSelected;
@end
