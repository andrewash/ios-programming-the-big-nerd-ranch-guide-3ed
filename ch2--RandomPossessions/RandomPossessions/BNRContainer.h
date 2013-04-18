//
//  BNRContainer.h
//  RandomPossessions
//
//  Created by aash on 2013-01-21.
//------------------------------------------------------------------------------------
//  Assignment #1, Q2 (Ch. 2, Gold Challenge)

#import "BNRItem.h"

@interface BNRContainer : BNRItem
{
    NSMutableArray *subitems;
}

- (id)initWithItemName: (NSString *)name
        valueInDollars: (int)value
          serialNumber: (NSString *)sNumber;
- (void)addItem: (BNRItem *)newItem;
- (int)valueInDollars;
@end

//====================================================================================
