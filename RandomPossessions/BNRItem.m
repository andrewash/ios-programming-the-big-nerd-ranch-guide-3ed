//
//  BNRItem.m
//  RandomPossessions
//
//  Created by aash on 2013-01-21.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                        itemName,
                        serialNumber,
                        valueInDollars,
                        dateCreated];
    return descriptionString;
}

- (void)setItemName: (NSString *)str
{
    itemName = str;
}
- (NSString *)itemName
{
    return itemName;
}

- (void)setSerialNumber: (NSString *)str
{
    serialNumber = str;
}
- (NSString *)serialNumber
{
    return serialNumber;
}

- (void)setValueInDollars: (int)i
{
    valueInDollars = i;
}
- (int)valueInDollars
{
    return valueInDollars;
}

- (NSDate *)dateCreated
{
    return dateCreated;
}
@end
