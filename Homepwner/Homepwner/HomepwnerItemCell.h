//
//  HomepwnerItemCell.h
//  Created by Andrew Ash on 8/8/2013.

#import <Foundation/Foundation.h>

@interface HomepwnerItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
