//
//  BNRItemStore.h
//  Created by aash on 2013-03-18.


#import <Foundation/Foundation.h>

@class BNRItem;  // tells compiler: "this class exists, but you don't need to know the details"


@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}
// Notice that this is a class method and prefixed with a + instead of a -
+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;


@end
