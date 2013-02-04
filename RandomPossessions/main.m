//
//  main.m
//  RandomPossessions
//
//  Created by aash on 2013-01-20.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"   // Assignment #1, Q2

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // Create a mutable array object, store its address in items variable
        NSMutableArray *items = [[NSMutableArray alloc] init];

        for (int i=0; i < 10; i++) {
            BNRItem *p = [BNRItem randomItem];
            [items addObject:p];
        }
        
        // Assignment #1, Q1 (Ch. 2, Silver Challenge)
        BNRItem *pSilverC = [[BNRItem alloc] initWithItemName:@"Silver Challenge" serialNumber:@"Q1R2Z"];
        [items addObject:pSilverC];
        // --
        
        for (BNRItem *item in items) {
            NSLog(@"%@", item);
        }
        
        // Assignment #1, Q2 (Ch. 2, Gold Challenge)
        BNRContainer *c = [[BNRContainer alloc] initWithItemName:@"Gregory 60L Backpack" valueInDollars:140 serialNumber:@"Q18S4"];
        for (int i=0; i < 5; i++) {
            [c addItem:[BNRItem randomItem]];
        }
        
        BNRContainer *c2 = [[BNRContainer alloc] initWithItemName:@"Ziploc bag" valueInDollars:1 serialNumber:@"N/A"];
        [c2 addItem:[[BNRItem alloc] initWithItemName:@"USB 3 cable" valueInDollars:6 serialNumber:@"N/A"]];
        [c2 addItem:[[BNRItem alloc] initWithItemName:@"Thunderbolt cable, 3'" valueInDollars:29 serialNumber:@"N/A"]];
        [c2 addItem:[[BNRItem alloc] initWithItemName:@"micro USB 2 cable" valueInDollars:5 serialNumber:@"N/A"]];
        
        [c addItem:c2];
        
        NSLog(@"%@", c);
        
        // Destroy the array pointed to by items
        items = nil;
    }
    return 0;
}

