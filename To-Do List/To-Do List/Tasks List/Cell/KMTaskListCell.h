//
//  KMTaskListCell.h
//  To-Do List
//
//  Created by Kirill on 11/8/15.
//  Copyright © 2015 Kirill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTaskListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;

@end
