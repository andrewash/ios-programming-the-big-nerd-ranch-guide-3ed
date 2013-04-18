//
//  BNRItem.h
//  RandomPossessions
//
//  Created by aash on 2013-01-21.

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    NSString *itemName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
}

+ (id)randomItem;

- (id)initWithItemName: (NSString *)name
        valueInDollars: (int)value
          serialNumber: (NSString *)sNumber;


//------------------------------------------------------------------------------------
// Assignment #1, Q1 (Ch. 2, Silver Challenge)
- (id)initWithItemName: (NSString *)name
          serialNumber: (NSString *)sNumber;
//====================================================================================

- (void)setItemName: (NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber: (NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars: (int)i;
- (int)valueInDollars;

- (NSDate *)dateCreated;
@end
