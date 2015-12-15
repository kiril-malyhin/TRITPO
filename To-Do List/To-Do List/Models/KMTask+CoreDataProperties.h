//
//  KMTask+CoreDataProperties.h
//  To-Do List
//
//  Created by Kirill on 11/8/15.
//  Copyright © 2015 Kirill. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KMTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMTask (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *taskNote;
@property (nullable, nonatomic, retain) NSDate *taskReminder;
@property (nullable, nonatomic, retain) NSString *taskTitle;
@property (nullable, nonatomic, retain) NSNumber *taskComplete;

@end

NS_ASSUME_NONNULL_END
