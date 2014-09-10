//
//  pinpoint2Tests.m
//  pinpoint2Tests
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPWorkingFuturesCard.h"

@interface pinpoint2Tests : XCTestCase

@end

@implementation pinpoint2Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    PPWorkingFuturesCard *card = [[PPWorkingFuturesCard alloc] init];
    [card setHtml:[card getHtmlTemplateStringFromName:@"working-futures-card"]];
    NSDictionary *data = @{@"title":@"job title"};
    [card addDataToCard:data];
    [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
    XCTAssert([[card isFinished] boolValue] == NO, @"Card is finished: %@", [card isFinished]);
    
    data = @{@"workingFuturesCommaSeparatedList":@"job,title"};
    [card addDataToCard:data];
    [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
    XCTAssertTrue([card isFinished], @"shouldn't be true");
}

@end
