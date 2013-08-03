//
//  BNRImageStore.m
//  Homepwner
//
//  Created by aash on 7/18/2013.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

// THIS CLASS IS A SINGLETON
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore {
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        // Register, so we can respond to low memory warnings (just as we do when user presses their device's Home button)
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}
// ---

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s {
    [dictionary setObject:i forKey:s];
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:s];
    
    // Turn image into a PNG representation
    NSData *d = UIImagePNGRepresentation(i);
    //NSData *d = UIImageJPEGRepresentation(i, 0.5);  // for JPEG representation
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s {
    // IF possible, get it from the dictionary
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        // If we found an image on the file system, place it into the cache
        if (result)
            [dictionary setObject:result forKey:s];
        else
            NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s {
    if (!s)
        return;
    [dictionary removeObjectForKey:s];
    
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:NULL];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
}
@end
