//
//  BNRItem.h
//  RandomPossessions
//
//  Created by aash on 2013-01-21.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    NSString *itemName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
}
- (void)doSomethingWeird;

+ (id)randomItem;

- (id)initWithItemName: (NSString *)name
        valueInDollars: (int)value
          serialNumber: (NSString *)sNumber;

- (void)setItemName: (NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber: (NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars: (int)i;
- (int)valueInDollars;

- (NSDate *)dateCreated;
@end
