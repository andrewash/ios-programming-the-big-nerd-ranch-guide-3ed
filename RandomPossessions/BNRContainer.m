//
//  BNRContainer.m
//  Assignment #1, Q2 (Ch. 2, Gold Challenge)

#import "BNRContainer.h"

@implementation BNRContainer

- (NSString *)description
{
    //learned to use an NSMutableString so we can append to it (an NSString is immutable)
    NSMutableString *descriptionString =
    [[NSMutableString alloc] initWithFormat:@"Container: %@ (%@): Worth $%d, recorded on %@",
     itemName,
     serialNumber,
     valueInDollars,
     dateCreated];
    
    // list contents of the container, relying on each BNRItem object to properly describe itself
    for (BNRItem *item in subitems) {
        [descriptionString appendFormat:@"\n\t%@", item];
    }

    //bug: Nested containers are not indented, so the output is a little tricky to read
    // resolved as: By Design)
    // notes:       Explored http://goo.gl/vse2U for options to fix this; decided it's acceptable as-is.
    [descriptionString appendFormat:@"\n\tTOTAL VALUE (including container):\t$%d", [self calcTotalValue]];
    
    return descriptionString;
}

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super initWithItemName:name valueInDollars:value serialNumber:sNumber];
    
    // Did the superclass initialize properly?
    if (self) {
        // initialize an empty array for subitems
        subitems = [[NSMutableArray alloc] init];
    }

    // Return a pointer to the newly initialized object
    return self;
}

- (void)addItem:(BNRItem *)newItem
{
    [subitems addObject:newItem];
}

- (int)calcTotalValue
{
    int totalValue = 0;
    
    for (BNRItem *item in subitems) {
        totalValue += [item valueInDollars];
    }
    
    // total value = {sum of values of each item in container} + {value of the container itself}
    totalValue += [self valueInDollars];

    return totalValue;
}



@end
