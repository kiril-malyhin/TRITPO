//
//  To_Do_ListUITests.m
//  To-Do ListUITests
//
//  Created by Kirill on 27.11.15.
//  Copyright © 2015 Andrey Savich. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface To_Do_ListUITests : XCTestCase

@end

@implementation To_Do_ListUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    [[[XCUIApplication alloc] init].navigationBars[@"To-Do List"].buttons[@"Add"] tap];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    //XCUIApplication *app = [[XCUIApplication alloc] init];
    /*[XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    [app.navigationBars[@"New Task"].buttons[@"To-Do List"] tap];
    [app.navigationBars[@"To-Do List"].buttons[@"Add"] tap];*/
    
    //XCTAsser([app.navigationBars[@"To-Do List"].buttons[@"Add"]exists]);
}

@end