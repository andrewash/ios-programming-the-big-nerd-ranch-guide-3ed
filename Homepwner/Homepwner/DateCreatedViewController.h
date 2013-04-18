//  DateCreatedViewController.h
//  Created by aash on 2013-04-15.


#import <UIKit/UIKit.h>

@class BNRItem;

@interface DateCreatedViewController : UIViewController
{
    __weak IBOutlet UIDatePicker *dateCreatedField;
}
// FYI - "The objects you create using NSDate are referred to as date objects. They are immutable objects."
//   this next line fixes bug where the BNRItem wasn't being updated when I only passed an NSDate to this controller
@property (nonatomic, strong) BNRItem *changeDateCreatedOnThisItem;

@end
