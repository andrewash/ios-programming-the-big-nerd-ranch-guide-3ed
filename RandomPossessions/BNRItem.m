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

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    
    // Return a pointer to the newly initialized object
    return self;
}

- (id)init
{
    return [self initWithItemName:@"Item"
                   valueInDollars:0
                     serialNumber:@""];
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
