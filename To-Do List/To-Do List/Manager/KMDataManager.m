//
//  KMDataManager.m
//  To-Do List
//
//  Created by Kirill on 09.11.15.
//  Copyright © 2015 Kirill. All rights reserved.
//

#import "KMDataManager.h"
//MagicalRecord
#import <MagicalRecord/MagicalRecord.h>

@implementation KMDataManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceTask;
    dispatch_once(&onceTask, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

#pragma mark - Task

- (void)saveNewTaskWithTitle:(NSString *)title
                        note:(NSString *)note
                    reminder:(NSDate *)reminder {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        KMTask *task = [KMTask MR_createEntityInContext:localContext];
        task.taskTitle = title;
        task.taskNote = note;
        task.taskComplete = @0;
        task.taskReminder = reminder;
        
        if (reminder != NULL) {
            [self createNotificationForTaskWithBody:title andReminder:reminder];
        }
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"Save");
    }];
}


- (NSArray *)getTasks {
    NSArray *array = [KMTask MR_findAllSortedBy:@"taskTitle" ascending:YES];
    return array;
}

- (void)deleteTask:(KMTask *)task {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [task MR_deleteEntityInContext:context];
    [context MR_saveToPersistentStoreAndWait];
}

- (void)saveEditTask:(KMTask *)task
        withNewTitle:(NSString *)title
                note:(NSString *)note {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        KMTask *newTask = [KMTask MR_createEntityInContext:localContext];
        newTask.taskTitle = title;
        newTask.taskNote = note;
        newTask.taskComplete = task.taskComplete;
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"update");
    }];
    
    [self deleteTask:task];
}

- (void)markCompleteTask:(KMTask *)task {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        KMTask *newTask = [KMTask MR_createEntityInContext:localContext];
        newTask.taskTitle = task.taskTitle;
        newTask.taskNote = task.taskNote;
        newTask.taskComplete = @1;
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"update");
    }];
    
    [self deleteTask:task];
}


#pragma mark - Additional Methods

- (NSString *)convertReminderPickerValue:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    NSString *pickerValue = [NSString stringWithFormat:@"%@",
                             [dateFormatter stringFromDate:date]];
    return pickerValue;
}

- (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    NSDate *currentDate = [NSDate date];
    NSString *date = [NSString stringWithFormat:@"%@",
                      [dateFormatter stringFromDate:currentDate]];
    
    return date;
}

#pragma mark - Notification

- (void)createNotificationForTaskWithBody:(NSString *)title
                              andReminder:(NSDate *)reminder {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = reminder;
    notification.regionTriggersOnce = YES;
    notification.alertBody = title;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
}


@end
