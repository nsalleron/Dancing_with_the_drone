//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 03/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerOptions.h"

@interface ViewOptions : UIView

@property (readonly,nonatomic,retain) UILabel *label;
@property (readwrite,nonatomic,retain) UIButton *btnDimensions;
@property (readonly,nonatomic,retain) UIButton *btnChangementMode;
@property (readonly,nonatomic,retain) UIButton *btnStatioDecoAttr;
@property (readonly,nonatomic,retain) UIButton *btnHome;
@property (readwrite,nonatomic,retain) UILongPressGestureRecognizer *longPress ;
@property (assign, nonatomic) CGFloat tailleIcones;

- (void) updateView:(CGSize) format;


@end
