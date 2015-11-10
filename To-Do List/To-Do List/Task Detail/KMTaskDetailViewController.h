//
//  KMTaskDetailViewController.h
//  To-Do List
//
//  Created by Kirill on 11/8/15.
//  Copyright © 2015 Kirill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMTask.h"
#import "KMTask+CoreDataProperties.h"

@interface KMTaskDetailViewController : UITableViewController

@property (strong, nonatomic) KMTask *task;

@end
