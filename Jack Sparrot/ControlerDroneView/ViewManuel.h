//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerManuel.h"

@interface ViewManuel : UIView

@property (readonly,nonatomic,retain) UILabel *label;
@property (readwrite,nonatomic,retain) UIButton *btnDimensions;
@property (readonly,nonatomic,retain) UIButton *btnChangementMode;
@property (readonly,nonatomic,retain) UIButton *btnStatioDecoAttr;
@property (readonly,nonatomic,retain) UIButton *btnHome;
@property (readwrite,nonatomic,retain) UILongPressGestureRecognizer *longPress ;
@property (assign, nonatomic) CGFloat tailleIcones;
@property (assign, nonatomic) ViewControllerManuel *vc;

- (void) updateView:(CGSize) format;
- (void)update2D3D:(CGSize)format;
- (void) updateBtnDimensions:(NSString*) item;
- (void) updateBtnChangementMode:(NSString*) item;
- (void) updateBtnStatioDecoAttr:(NSString*) item;
- (void) setViewController:(ViewControllerManuel *) me;
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture;
@end
