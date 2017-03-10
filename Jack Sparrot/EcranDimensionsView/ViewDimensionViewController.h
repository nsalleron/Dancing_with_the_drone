//
//  ViewDimensionViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <UIKit/UIKit.h>

@class ViewDimensionViewController;

// Nom du protocol
@protocol ViewDimensionViewControllerDelegate <NSObject>
//Méthode du protocol
- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface ViewDimensionViewController : UIViewController

//Delegate du protocole, le viewcontroller accepte ce protocole.
@property (nonatomic, weak) id <ViewDimensionViewControllerDelegate> delegate;

@end

