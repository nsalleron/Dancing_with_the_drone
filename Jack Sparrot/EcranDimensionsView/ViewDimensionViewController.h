//
//  ViewDimensionViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <UIKit/UIKit.h>

@class ViewDimensionViewController;

@protocol ViewDimensionViewControllerDelegate <NSObject>
- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface ViewDimensionViewController : UIViewController

@property (nonatomic, weak) id <ViewDimensionViewControllerDelegate> delegate;

@end

