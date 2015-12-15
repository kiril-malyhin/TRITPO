//
//  KMDataManager.m
//  To-Do List
//
//  Created by Kirill on 09.11.15.
//  Copyright © 2015 Kirill. All rights reserved.
//


#import <Foundation/Foundation.h>
//Models
#import "KMTask.h"
#import "KMTask+CoreDataProperties.h"

@interface KMDataManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Task

- (void)saveNewTaskWithTitle:(NSString *)title
                        note:(NSString *)note
                    reminder:(NSDate *)reminder;

- (NSArray *)getTasks;
- (void)deleteTask:(KMTask *)task;

- (void)saveEditTask:(KMTask *)task
        withNewTitle:(NSString *)title
                note:(NSString *)note;

- (void)markCompleteTask:(KMTask *)task;

#pragma mark - Additional Methods

- (NSString *)convertReminderPickerValue:(NSDate *)date;
- (NSString *)currentDate;

@end
