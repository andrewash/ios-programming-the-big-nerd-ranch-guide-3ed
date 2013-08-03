//
//  BNRImageStore.h
//  Homepwner
//
//  Created by aash on 7/18/2013.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (BNRImageStore *)sharedStore;

- (NSString *)imagePathForKey:(NSString *)key;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;

@end
