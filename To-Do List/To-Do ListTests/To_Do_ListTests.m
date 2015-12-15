//
//  To_Do_ListTests.m
//  To-Do ListTests
//
//  Created by Kirill on 27.11.15.
//  Copyright © 2015 Andrey Savich. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KMDataManager.h"

@interface To_Do_ListTests : XCTestCase

@end

@implementation To_Do_ListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Task Count

- (void)testTasksCount {
    NSArray *tasks = [[KMDataManager sharedInstance]getTasks];
    NSUInteger *taskCount = [tasks count];
    
    NSArray *expectedTasks = [[KMDataManager sharedInstance]getTasks];
    NSUInteger *expectedTasksCount = [expectedTasks count];
    XCTAssertEqual(taskCount, expectedTasksCount,@"tasksCount and expectedTasksCount are not equal");
}

- (void)testGetTaskPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSArray *task = [[KMDataManager sharedInstance]getTasks];
    
    }];
}

#pragma mark - Greeting

- (void)testGreeting {
    NSString *greetingString = [[KMDataManager sharedInstance]greeting];
    
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *expectedGreetingString;
    CGFloat currentHour = [localDateString floatValue];
    if (currentHour >= 4.f && currentHour < 12.f) {
        expectedGreetingString = @"Good Morning !";
    }
    else if (currentHour >= 12.f && currentHour < 17.f) {
        expectedGreetingString = @"Good Afternoon !";
    }
    else if (currentHour >= 17.f && currentHour < 23.f) {
        expectedGreetingString = @"Good Evening !";
    }
    else if (currentHour >= 23.f && currentHour < 4.f ) {
        expectedGreetingString = @"Good Night !";
    }
    
    XCTAssertEqualObjects(greetingString, expectedGreetingString, @"The greetingString string did not match the expectedGreetingString");
}

@end