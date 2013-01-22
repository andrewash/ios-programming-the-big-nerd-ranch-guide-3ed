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

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffly",
                                                             @"Rusty",
                                                             @"Shiny",
                                                             @"Happy",
                                                             @"Confused",
                                                             @"Purple",
                                                             nil];
    
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                                                        @"Spork",
                                                        @"Mac",
                                                        @"Klingon",
                                                        @"Walnuts",
                                                        @"Metal",
                                                        nil];
    
    // Get the index of a random adjective/noun from the lists
    // note the % (modulo) operator, which gives the remainder
    // i.e. adjectiveIndex == random number between 0..2, where 2 is [randomAdjectiveList count]
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    // Note tha tNSINteger is not an object, but a type definition
    //  for "unsigned long"
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                '0' + rand() % 10,
                                'A' + rand() % 26,
                                '0' + rand() % 10,
                                'A' + rand() % 26,
                                '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    return newItem;
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
