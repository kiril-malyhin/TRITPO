//
//  KMListTaskTableViewController.m
//  To-Do List
//
//  Created by Kirill on 09.11.15.
//  Copyright © 2015 Kirill. All rights reserved.
//

#import "KMListTaskTableViewController.h"
#import "KMNewTaskViewController.h"
#import "KMTaskDetailViewController.h"
#import "KMDataManager.h"
#import "KMHeaderView.h"
//Models
#import "KMTask.h"
#import "KMTask+CoreDataProperties.h"
//Cell
#import "KMTaskListCell.h"

static const NSInteger kStretchyHeaderViewCutAway = 50.f;
static const NSInteger kHeaderViewHeight = 200.f;

@interface KMListTaskTableViewController ()

@property (strong, nonatomic) NSArray *tasks;
@property (strong, nonatomic)KMHeaderView *headerView;
@property (strong, nonatomic) CAShapeLayer *headerViewMaskLayer;

- (IBAction)createTask:(id)sender;

@end

@implementation KMListTaskTableViewController

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getTasks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateHeaderView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateHeaderView];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

#pragma mark - Header View

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.headerView = (KMHeaderView *)self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;
    [self.tableView addSubview:self.headerView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kHeaderViewHeight);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    self.headerViewMaskLayer = [[CAShapeLayer alloc]init];
    self.headerViewMaskLayer.fillColor = [UIColor blackColor].CGColor;
    self.headerView.layer.mask = self.headerViewMaskLayer;
    
    [self updateHeaderView];
}

- (void)updateHeaderView {
    CGFloat stretchyHeaderEffectiveHeight = + self.headerView.bounds.size.height - kStretchyHeaderViewCutAway / 2;
    
    CGRect stretchyHeaderRect = CGRectMake(0, -stretchyHeaderEffectiveHeight,
                                           self.tableView.bounds.size.width, kHeaderViewHeight);
    
    if (self.tableView.contentOffset.y < - stretchyHeaderEffectiveHeight) {
        stretchyHeaderRect.origin.y = self.tableView.contentOffset.y;
        stretchyHeaderRect.size.height = -self.tableView.contentOffset.y - kStretchyHeaderViewCutAway / 2;
    }
    self.headerView.frame = stretchyHeaderRect;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(stretchyHeaderRect.size.width, 0)];
    [path addLineToPoint:CGPointMake(stretchyHeaderRect.size.width, stretchyHeaderRect.size.height)];
    [path addLineToPoint:CGPointMake(0, stretchyHeaderRect.size.height + kStretchyHeaderViewCutAway)];
    
    self.headerViewMaskLayer.path = path.CGPath;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tasks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self taskCellAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (KMTaskListCell *)taskCellAtIndexPath:(NSIndexPath *)indexPath {
    KMTask *task = self.tasks[indexPath.row];
    
    KMTaskListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    cell.taskNumberLabel.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row + 1];
    cell.taskTitleLabel.text = task.taskTitle;

    
    if ([task.taskComplete integerValue] == 1) {
        cell.taskNumberLabel.textColor = [UIColor lightGrayColor];
        cell.taskTitleLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.taskNumberLabel.textColor = [UIColor blackColor];
        cell.taskTitleLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KMTask *task = self.tasks[indexPath.row];
    
    KMTaskDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetail"];
    vc.task = task;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    KMTask *task = self.tasks[indexPath.row];

    if ([task.taskComplete integerValue] == 1) {
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"
                                                                        handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                            [self showAlertForDeletingTaskAtIndexPath:indexPath];
                                                                        }];
        delete.backgroundColor = [UIColor redColor];
        
        NSArray<UITableViewRowAction *> *action = @[delete];
        return action;
    }
    else {
        UITableViewRowAction *compele = [UITableViewRowAction rowActionWithStyle:
                                         UITableViewRowActionStyleNormal title:@"Complete"
                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                            [self completeTaskAtIndexPath:indexPath];
                                                            [self getTasks];
                                                            [tableView reloadData];
                                        }];
        compele.backgroundColor = [UIColor lightGrayColor];
        
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"
                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                    [self showAlertForDeletingTaskAtIndexPath:indexPath];
                                            }];
        delete.backgroundColor = [UIColor redColor];
        
        NSArray<UITableViewRowAction *> *action = @[compele, delete];
        return action;
    }
}

#pragma mark - Alert

- (void)showAlertForDeletingTaskAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                   message:@"This action cannot be revert" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self deleteTaskAtIndexPath:indexPath];
                                                         [self getTasks];
                                                
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Request

- (void)getTasks {
    self.tasks = [[KMDataManager sharedInstance]getTasks];
    
    if (self.tasks.count != 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.tableView reloadData];
    }
    else {
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,
                                                                         self.view.bounds.size.width,
                                                                         self.view.bounds.size.height)];
        
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"No task. Please click 'Add' button";
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.tableView reloadData];
    }
}

- (void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {
    KMTask *task = self.tasks[indexPath.row];
    [[KMDataManager sharedInstance]deleteTask:task];
}

- (void)completeTaskAtIndexPath:(NSIndexPath *)indexPath {
    KMTask *task = self.tasks[indexPath.row];
    [[KMDataManager sharedInstance]markCompleteTask:task];
}


#pragma mark - Action

- (IBAction)createTask:(id)sender {
    
    KMNewTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end