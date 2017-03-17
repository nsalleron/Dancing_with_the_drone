//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerOptions.h"

@interface ViewOptions : UIView

@property (readonly,nonatomic,retain) UILabel *lblHauteurMax;
@property (readonly,nonatomic,retain) UILabel *lblCoeffAccel;
@property (readonly,nonatomic,retain) UILabel *lblModeIntExt;
@property (readonly,nonatomic,retain) UILabel *lblCouleurDim;

@property (readwrite,nonatomic,retain) UIColor *color1D;
@property (readwrite,nonatomic,retain) UIColor *color2D;
@property (readwrite,nonatomic,retain) UIColor *color3D;
@property (readwrite,nonatomic,retain) UIColor *colorX;
@property (readwrite,nonatomic,retain) UIColor *colorY;

@property (readwrite, nonatomic, retain) UISwitch *swhInOut;

@property (readwrite,nonatomic,retain) UIButton *btnColor1D;
@property (readwrite,nonatomic,retain) UIButton *btnColor2D;
@property (readwrite,nonatomic,retain) UIButton *btnColor3D;
@property (readwrite,nonatomic,retain) UIButton *btnColorAxeX;
@property (readwrite,nonatomic,retain) UIButton *btnColorAxeY;

@property (readonly,nonatomic,retain) UILabel *lblHauteurMaxInt;
@property (readonly,nonatomic,retain) UILabel *lblCoeffAccelInt;

@property (readwrite, nonatomic, retain) IBOutlet UIStepper *stpHauteurMax;
@property (readwrite, nonatomic, retain) IBOutlet UIStepper *stpCoeffAccel;

@property (assign, nonatomic) CGFloat tailleIcones;
@property (assign, nonatomic) ViewControllerOptions *vc;

- (void) updateView:(CGSize) format;
- (void) updateBtn:(int)btn color: (UIColor*) color;
- (IBAction)stepperHauteurMaxUpdate:(UIStepper *)sender;
- (IBAction)stepperCoeffAccelUpdate:(UIStepper *)sender;
- (NSArray *) getBtnColors;

@end
