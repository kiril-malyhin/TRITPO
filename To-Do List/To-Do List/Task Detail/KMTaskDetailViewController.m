//
//  KMTaskDetailViewController.m
//  To-Do List
//
//  Created by Kirill on 11/8/15.
//  Copyright © 2015 Kirill. All rights reserved.
//

#import "KMTaskDetailViewController.h"
#import "KMDataManager.h"
#import "KMNewTaskViewController.h"
//Cells
#import "KMTaskNoteCell.h"
#import "KMTaskTitleCell.h"
#import "KMTaskSaveCell.h"

typedef NS_ENUM(NSInteger, KMTaskDetailViewControllerCell) {
    KMTaskDetailViewControllerCellForTaskTitle = 0,
    KMTaskDetailViewControllerCellForTaskNote = 1,
    KMTaskDetailViewControllerCellForReminder = 2,
    KMTaskDetailViewControllerCellForSave = 3
};

@interface KMTaskDetailViewController ()

@end

@implementation KMTaskDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure View

- (void)configureView {
    self.tableView.estimatedRowHeight = 60.f;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"Edit Task";
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == KMTaskDetailViewControllerCellForTaskTitle ) {
        return [self taskTitleCellAtIndexPath:indexPath];
    }
    else if (indexPath.row == KMTaskDetailViewControllerCellForTaskNote) {
        return [self taskNoteCellAtIndexPath:indexPath];
    }
    else if (indexPath.row == KMTaskDetailViewControllerCellForReminder){
        return [self taskTitleCellAtIndexPath:indexPath];
    }
    
    else {
        return [self taskSaveCellAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == KMTaskDetailViewControllerCellForSave) {
        return  60.f;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - Configure Cells

- (KMTaskTitleCell *)taskTitleCellAtIndexPath:(NSIndexPath *)indexPath {
    KMTaskTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"info"
                                                            forIndexPath:indexPath];
    
    if (indexPath.row == KMTaskDetailViewControllerCellForTaskTitle) {
        cell.taskParameterLabel.text = @"Title:";
        cell.taskParameterValue.text = self.task.taskTitle;
    }
    if (indexPath.row == KMTaskDetailViewControllerCellForReminder) {
        cell.taskParameterLabel.text = @"Reminder:";
        
        if (self.task.taskReminder == NULL) {
            cell.taskParameterValue.text = @"Not set";
        }
        else {
            NSString *dateString = [[KMDataManager sharedInstance]
                                    convertReminderPickerValue:self.task.taskReminder];
            cell.taskParameterValue.text = dateString;
        }
    }
    
    return cell;
}

- (KMTaskNoteCell *)taskNoteCellAtIndexPath:(NSIndexPath *)indexPath {
    KMTaskNoteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"taskNote"
                                                           forIndexPath:indexPath];
    if (self.task.taskNote == NULL) {
        cell.taskNoteLabel.text = @"Not set";
    }
    else {
        cell.taskNoteLabel.text = self.task.taskNote;
    }
    return cell;
}

- (KMTaskSaveCell *)taskSaveCellAtIndexPath:(NSIndexPath *)indexPath {
    KMTaskSaveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"save"
                                                           forIndexPath:indexPath];
    
    [cell.taskSaveButton addTarget:self
                            action:@selector(editTask:)
                  forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - Actions

- (void)editTask:(id)sender {
    KMNewTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
    vc.task = self.task;
    [self.navigationController pushViewController:vc animated:YES];
}

@end