//
//  KMNewTaskViewController.m
//  To-Do List
//
//  Created by Kirill on 11/8/15.
//  Copyright © 2015 Kirill. All rights reserved.
//

#import "KMNewTaskViewController.h"
#import <LGActionSheet/LGActionSheet.h>
#import "KMDataManager.h"

typedef NS_ENUM(NSInteger, KMNewTaskViewControllerTextField) {
    KMNewTaskViewControllerTextFieldForTaskTitle = 0,
    KMNewTaskViewControllerTextFieldForTaskNote = 1,
    KMNewTaskViewControllerTextFieldForReminder = 2,
};

@interface KMNewTaskViewController () <UITextFieldDelegate, LGActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *taskNoteTextField;
@property (weak, nonatomic) IBOutlet UITextField *taskReminderTextField;
@property (weak, nonatomic) IBOutlet UIButton *clearReminderButton;

@property (strong, nonatomic) NSDate *taskReminder;
@property (strong, nonatomic) UIDatePicker *taskReminderPicker;

- (IBAction)clearReminder:(id)sender;
- (IBAction)saveTask:(id)sender;

@end

@implementation KMNewTaskViewController

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
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.title = @"New Task";
    self.clearReminderButton.hidden = YES;
    
    if (self.task != NULL) {
        self.title = @"Edit Task";
        self.taskTitleTextField.text = self.task.taskTitle;
        self.taskNoteTextField.text = self.task.taskNote;
        
        if (self.task.taskReminder == NULL) {
            self.taskReminderTextField.text = @"Not set";
        }
        else {
            NSString *dateString = [[KMDataManager sharedInstance]
                                    convertReminderPickerValue:self.task.taskReminder];
            
            self.taskReminderTextField.text = dateString;
            self.clearReminderButton.hidden = NO;
        }
    }

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == KMNewTaskViewControllerTextFieldForReminder) {
        [self showDueDateActionSheet];
        [textField resignFirstResponder];
        textField.text = [[KMDataManager sharedInstance]currentDate];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Date and Time Pickers

- (void)createReminderPicker {
    self.taskReminderPicker = [[UIDatePicker alloc]init];
    self.taskReminderPicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    NSDate *currentDate = [NSDate date];
    self.taskReminderPicker.minimumDate = currentDate;
    self.taskReminderPicker.date = currentDate;
    
    [self.taskReminderPicker addTarget:self
                                action:@selector(reminderPickerValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
}

- (void)reminderPickerValueChanged:(id)sender {
    NSString *pickerValue = [[KMDataManager sharedInstance]
                             convertReminderPickerValue:self.taskReminderPicker.date];
    NSLog(@"Picker %@",self.taskReminderPicker.date);
    
    self.taskReminder = self.taskReminderPicker.date;
    self.taskReminderTextField.text = pickerValue;
}

#pragma mark - ActionSheets

- (void)showDueDateActionSheet {
    [self createReminderPicker];
    
    LGActionSheet *actionSheet = [[LGActionSheet alloc]initWithTitle:@"Set Date"
                                                                view:self.taskReminderPicker
                                                        buttonTitles:nil
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Done"];
    [actionSheet showAnimated:YES completionHandler:nil];
    
    self.clearReminderButton.hidden = NO;
}

#pragma mark - Action

- (IBAction)clearReminder:(id)sender {
    self.taskReminderTextField.text = @" ";
    self.clearReminderButton.hidden = YES;
    
    self.taskReminder = NULL;
}

- (IBAction)saveTask:(id)sender {
    NSString *taskTitle = self.taskTitleTextField.text;
    NSString *taskNote = self.taskNoteTextField.text;
    
    [[KMDataManager sharedInstance]saveNewTaskWithTitle:taskTitle
                                                   note:taskNote
                                               reminder:self.taskReminder];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end