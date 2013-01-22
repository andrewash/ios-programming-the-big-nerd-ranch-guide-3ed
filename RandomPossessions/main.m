//
//  main.m
//  RandomPossessions
//
//  Created by aash on 2013-01-20.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // Create a mutable array object, store its address in items variable
        NSMutableArray *items = [[NSMutableArray alloc] init];

        BNRItem *p = [[BNRItem alloc] initWithItemName:@"Red Sofa"
                                        valueInDollars:100
                                          serialNumber:@"A1B2C"];
        
        NSLog(@"%@", p);
        
        // Destroy the array pointed to by items
        items = nil;
    }
    return 0;
}

