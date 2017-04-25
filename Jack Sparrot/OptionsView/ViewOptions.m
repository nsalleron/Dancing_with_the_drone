//
//  ViewManuel.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <Foundation/Foundation.h>
#import "ViewOptions.h"
#import "ViewControllerOptions.h"


@implementation ViewOptions


- (void) getUserSettings{
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"1D"];
        
    if (colorData != nil) {
        
        self.color1D = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"2D"];
        if (colorData != nil) {
            self.color2D = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
        colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"3D"];
        if (colorData != nil) {
            self.color3D = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
        colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Axe X"];
        if (colorData != nil) {
            self.colorX = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
        colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Axe Y"];
        if (colorData != nil) {
           self.colorY = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
    }else{ // Mise en place des couleurs par défaut.
        
        self.color1D = [[UIColor alloc] initWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1.0];
        self.color2D = [[UIColor alloc] initWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0];
        self.color3D = [[UIColor alloc] initWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
        self.colorX = [[UIColor alloc] initWithRed:155/255.0 green:89/255.0 blue:182/255.0 alpha:1.0];
        self.colorY = [[UIColor alloc] initWithRed:52/255.0 green:73/255.0 blue:94/255.0 alpha:1.0];
    }
    
    double tmp = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Acceleration"];
    [_stpCoeffAccel setValue:tmp];
    
    tmp = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Hauteur"];
    [_stpHauteurMax setValue:tmp];
    
    bool tmpB = [[NSUserDefaults standardUserDefaults] boolForKey:@"InOut"];
    [_swhInOut setOn:(tmpB)];
    
    /* Mise en place des couleurs par défaut */
    NSLog(@"Colorisation...");
    /* Mise en place des couleurs par défaut + changement couleur texte */
    [self btnColorText];
    
    [_btnColor1D setBackgroundColor:_color1D];
    [_btnColor2D setBackgroundColor:_color2D];
    [_btnColor3D setBackgroundColor:_color3D];
    [_btnColorAxeX setBackgroundColor:_colorX];
    [_btnColorAxeY setBackgroundColor:_colorY];

}

- (void) btnColorText{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;

    [_color1D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnColor1D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnColor1D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_color2D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnColor2D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnColor2D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_color3D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnColor3D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnColor3D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_colorX getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnColorAxeX setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnColorAxeX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_colorY getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnColorAxeY setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnColorAxeY setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


- (void) updateBtn:(int)btn color: (UIColor*) color{
    if (color != nil){
        switch (btn) {
            case 1:
                _color1D = color;
                [_btnColor1D setBackgroundColor:_color1D];
                
                break;
            case 2:
                _color2D = color;
                [_btnColor2D setBackgroundColor:_color2D];
                break;
            case 3:
                _color3D = color;
                [_btnColor3D setBackgroundColor:_color3D];
                break;
            case 4:
                _colorX = color;
                [_btnColorAxeX setBackgroundColor:_colorX];
                break;
            case 5:
                _colorY = color;
                [_btnColorAxeY setBackgroundColor:_colorY];
                break;
            default:
                
                break;
        }
    }
    [self btnColorText];
    
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* INITIALSATIONS */
        _btnColor1D = [[UIButton alloc] init];
        _btnColor2D = [[UIButton alloc] init];
        _btnColor3D = [[UIButton alloc] init];
        _btnColorAxeX = [[UIButton alloc] init];
        _btnColorAxeY = [[UIButton alloc] init];
        _stpHauteurMax = [[UIStepper alloc] init];
        _stpCoeffAccel = [[UIStepper alloc] init];
        _swhInOut = [[UISwitch alloc] init];
        _lblHauteurMax = [[UILabel alloc] init];
        _lblCoeffAccel = [[UILabel alloc] init];
        _lblCouleurDim = [[UILabel alloc] init];
        _lblModeIntExt = [[UILabel alloc] init];
        _lblModeIntExtBool = [[UILabel alloc] init];
        
        /* BOUTONS */
        [_btnColor1D setTitle:@"1D" forState:UIControlStateNormal];
        [_btnColor1D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnColor1D layer] setBorderWidth:1.0f];
        [[_btnColor1D layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnColor1D layer] setCornerRadius:1.0f];
        [[_btnColor1D layer] setBorderWidth:1.0f];
        [_btnColor1D addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnColor2D setTitle:@"2D" forState:UIControlStateNormal];
        [_btnColor2D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnColor2D layer] setBorderWidth:1.0f];
        [[_btnColor2D layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnColor2D layer] setCornerRadius:1.0f];
        [[_btnColor2D layer] setBorderWidth:1.0f];
        [_btnColor2D addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnColor3D setTitle:@"3D" forState:UIControlStateNormal];
        [_btnColor3D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnColor3D layer] setBorderWidth:1.0f];
        [[_btnColor3D layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnColor3D layer] setCornerRadius:1.0f];
        [[_btnColor3D layer] setBorderWidth:1.0f];
        [_btnColor3D addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnColorAxeX setTitle:@"Axe X" forState:UIControlStateNormal];
        [_btnColorAxeX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnColorAxeX layer] setBorderWidth:1.0f];
        [[_btnColorAxeX layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnColorAxeX layer] setCornerRadius:1.0f];
        [[_btnColorAxeX layer] setBorderWidth:1.0f];
        [_btnColorAxeX addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnColorAxeY setTitle:@"Axe Y" forState:UIControlStateNormal];
        [_btnColorAxeY setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnColorAxeY layer] setBorderWidth:1.0f];
        [[_btnColorAxeY layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnColorAxeY layer] setCornerRadius:1.0f];
        [[_btnColorAxeY layer] setBorderWidth:1.0f];
        [_btnColorAxeY addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        /* Colorisation des boutons */
        [self getUserSettings];
        
        [self addSubview:_btnColor1D];
        [self addSubview:_btnColor2D];
        [self addSubview:_btnColor3D];
        [self addSubview:_btnColorAxeX];
        [self addSubview:_btnColorAxeY];
        [self addSubview:_swhInOut];
        
        [self addSubview:_lblHauteurMax];
        [self addSubview:_lblCoeffAccel];
        [self addSubview:_lblCouleurDim];
        [self addSubview:_lblModeIntExt];
        [self addSubview:_lblModeIntExtBool];
        
        /* Mise en place des labels */
        [_lblHauteurMax setText:@"Hauteur max. (m) :"];
        [_lblCoeffAccel setText:@"Coeff. acceleration :"];
        [_lblCouleurDim setText:@"Couleurs boutons :"];
        [_lblModeIntExt setText:@"Fonction HOME :"];
        [_lblModeIntExtBool setText:@"Intérieur"];
        
        [_stpHauteurMax setAutorepeat:YES];
        [_stpHauteurMax setMinimumValue:2.0];
        [_stpHauteurMax setMaximumValue:30];
        [_stpHauteurMax setStepValue:0.5];
        
        [_stpCoeffAccel setAutorepeat:YES];
        [_stpCoeffAccel setMinimumValue:1.0];
        [_stpCoeffAccel setMaximumValue:2.0];
        [_stpCoeffAccel setStepValue:0.05];
        
        _lblHauteurMaxInt = [[UILabel alloc] init];
        [_lblHauteurMaxInt setText:[NSString stringWithFormat:@"%.2f", _stpHauteurMax.value]];
        
        _lblCoeffAccelInt = [[UILabel alloc] init];
        [_lblCoeffAccelInt setText:[NSString stringWithFormat:@"%.2f", _stpCoeffAccel.value]];
        
        if ([_swhInOut isOn])
            [_lblModeIntExtBool setText:[NSString stringWithFormat:@"Intérieur"]];
        else
            [_lblModeIntExtBool setText:[NSString stringWithFormat:@"Extérieur"]];
        
        [self addSubview:_lblHauteurMaxInt];
        [self addSubview:_lblCoeffAccelInt];
        [self addSubview:_stpHauteurMax];
        [self addSubview:_stpCoeffAccel];
        
        [_stpHauteurMax addTarget:self action:@selector(stepperHauteurMaxUpdate:) forControlEvents:UIControlEventValueChanged];
        [_stpCoeffAccel addTarget:self action:@selector(stepperCoeffAccelUpdate:) forControlEvents:UIControlEventValueChanged];
        [_swhInOut addTarget:self action:@selector(switchModeIntExt:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_lblModeIntExtBool];
        
        
    }
    
    return self;
}


- (void)updateView:(CGSize)format{
   
    _tailleMarges = 6;
    
    /*Mise en place des boutons et labels */
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        _tailleIcones = (format.height-32)/6;
        
        [_lblModeIntExt setFrame:CGRectMake(format.width/6, 32, format.width/3, _tailleIcones)];
        [_lblModeIntExtBool setFrame:CGRectMake(format.width/6+format.width/3, 32, format.width/3, _tailleIcones)];
        [_swhInOut setFrame:CGRectMake(2*format.width/3, 40, format.width/6, _tailleIcones)];
        
        [_lblHauteurMax setFrame:CGRectMake(format.width/6, 32+_tailleIcones, format.width/3, _tailleIcones)];
        [_lblHauteurMaxInt setFrame:CGRectMake(format.width/6+format.width/3, 32+_tailleIcones+2, format.width/6, _tailleIcones-4)];
        [_stpHauteurMax setFrame:CGRectMake(2*format.width/3, 32+_tailleIcones+5, format.width/6, _tailleIcones-4)];
        
        [_lblCoeffAccel setFrame:CGRectMake(format.width/6, 32+2*_tailleIcones, format.width/3, _tailleIcones)];
        [_lblCoeffAccelInt setFrame:CGRectMake(format.width/6+format.width/3, 32+2*_tailleIcones+2, format.width/3, _tailleIcones-4)];
        [_stpCoeffAccel setFrame:CGRectMake(2*format.width/3, 32+2*_tailleIcones+5, format.width/3, _tailleIcones-4)];
        
        [_lblCouleurDim setFrame:CGRectMake(format.width/6, 32+3*_tailleIcones, format.width/3, _tailleIcones)];
        
        [_btnColor1D setFrame:CGRectMake(0, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnColor2D setFrame:CGRectMake(format.width/3, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnColor3D setFrame:CGRectMake(2*format.width/3, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        
        [_btnColorAxeX setFrame:CGRectMake(format.width/6, 32+5*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnColorAxeY setFrame:CGRectMake(format.width/6+format.width/3, 32+5*_tailleIcones, format.width/3, _tailleIcones)];
        
    }else{
        _tailleIcones = (format.height-64)/6;
        [_lblModeIntExt setFrame:CGRectMake(_tailleMarges, 64, (format.width/2)-_tailleMarges, _tailleIcones)];
        [_lblModeIntExtBool setFrame:CGRectMake(_tailleMarges+format.width/2, 64, format.width/2, _tailleIcones)];
        [_swhInOut setFrame:CGRectMake(format.width/2+format.width/4, 64+_tailleIcones/3, format.width/4, _tailleIcones)];
        
        [_lblHauteurMax setFrame:CGRectMake(_tailleMarges, 64+_tailleIcones, (format.width/2)-_tailleMarges, _tailleIcones)];
        [_lblHauteurMaxInt setFrame:CGRectMake(format.width/2, 64+_tailleIcones, format.width/4, _tailleIcones)];
        [_stpHauteurMax setFrame:CGRectMake(format.width/2+format.width/4-20, 64+_tailleIcones+30, format.width/4, _tailleIcones)];
        
        [_lblCoeffAccel setFrame:CGRectMake(_tailleMarges, 64+2*_tailleIcones, (format.width/2)-5, _tailleIcones)];
        [_lblCoeffAccelInt setFrame:CGRectMake(_tailleMarges+format.width/2, 64+2*_tailleIcones, format.width/4, _tailleIcones)];
        [_stpCoeffAccel setFrame:CGRectMake(format.width/2+format.width/4-20, 64+2*_tailleIcones+30, format.width/4, _tailleIcones)];
        
        [_lblCouleurDim setFrame:CGRectMake(_tailleMarges, 64+3*_tailleIcones, (format.width/2)-_tailleMarges, _tailleIcones)];
        [_btnColor1D setFrame:CGRectMake(format.width/2, 64+3*_tailleIcones, (format.width/2)-_tailleMarges, _tailleIcones-2)];
        
        [_btnColor2D setFrame:CGRectMake(format.width/2, (64+4*_tailleIcones)-2, (format.width/2)-_tailleMarges, _tailleIcones-2)];
        [_btnColor3D setFrame:CGRectMake(format.width/2, (64+5*_tailleIcones)-4, (format.width/2)-_tailleMarges, _tailleIcones-2)];
        
        [_btnColorAxeX setFrame:CGRectMake(_tailleMarges, (64+4*_tailleIcones)-2, (format.width/2)-_tailleMarges, _tailleIcones-2)];
        [_btnColorAxeY setFrame:CGRectMake(_tailleMarges, (64+5*_tailleIcones)-4, (format.width/2)-_tailleMarges, _tailleIcones-2)];
        
    }
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


- (NSArray *) getBtnColors{
    NSArray *tmp = [[NSArray alloc] initWithObjects:
                    [_btnColor1D backgroundColor],
                    [_btnColor2D backgroundColor],
                    [_btnColor3D backgroundColor],
                    [_btnColorAxeX backgroundColor],
                    [_btnColorAxeY backgroundColor],nil];
    return tmp;
}


-(IBAction)stepperHauteurMaxUpdate:(UIStepper *)sender{
    [_lblHauteurMaxInt setText:[NSString stringWithFormat:@"%.2f", _stpHauteurMax.value]];
}

-(IBAction)stepperCoeffAccelUpdate:(UIStepper *)sender{
    [_lblCoeffAccelInt setText:[NSString stringWithFormat:@"%.2f", _stpCoeffAccel.value]];
}


- (IBAction)switchModeIntExt:(UISwitch *)sender{
    if ([_swhInOut isOn])
        [_lblModeIntExtBool setText:[NSString stringWithFormat: @"Intérieur"]];
    else
        [_lblModeIntExtBool setText:[NSString stringWithFormat:@"Extérieur"]];
}


-(double) getStepperValueCoefAcce{
    return [_stpCoeffAccel value];
}

- (double) getStepperValueMax{
    return [_stpHauteurMax value];
}

- (BOOL) getSwitchValueInOut{
    return [_swhInOut isOn];
}

@end
