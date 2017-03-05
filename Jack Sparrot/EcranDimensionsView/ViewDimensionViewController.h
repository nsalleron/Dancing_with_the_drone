//
//  ViewDimensionViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <UIKit/UIKit.h>

@protocol senddataProtocol <NSObject>

-(void)sendDimensions:(NSString *)dim;
-(void) endDimensionChoice:(UIButton*)send;

@end

@interface ViewDimensionViewController : UIViewController

@property(nonatomic,assign)id delegate;


@end



