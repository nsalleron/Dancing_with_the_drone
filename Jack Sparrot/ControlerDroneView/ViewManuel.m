//
//  ViewManuel.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import "ViewManuel.h"
#import "ViewControllerManuel.h"


@implementation ViewManuel


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
    
    /* Mise en place des couleurs par défaut + changement couleur texte */
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_color1D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnDimensions setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_btnDimensions setBackgroundColor:_color1D];
    
    [_colorX getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnChangementMode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_btnChangementMode setBackgroundColor:_colorX];
    
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        /* Boutons */
        _btnChangementMode = [[UIButton alloc] init];
        _btnStatioDecoAttr  = [[UIButton alloc] init];
        _btnHome  = [[UIButton alloc] init];
        _btnDimensions = [[UIButton alloc] init];
        
        /* Personnalisation */
        [_btnDimensions setTitle:@"1D" forState:UIControlStateNormal];
        UIImage *btnImage = [UIImage imageNamed:@"dim.png"];
        [_btnDimensions setImage:btnImage forState:UIControlStateNormal];
        
        [_btnChangementMode setTitle:@"btnChangementDeMode" forState:UIControlStateNormal];
        [_btnStatioDecoAttr  setTitle:@"btnStatioDecoAttr" forState:UIControlStateNormal];
        
        
        [_btnHome setTitle:@"      Home" forState:UIControlStateNormal];
        btnImage = [UIImage imageNamed:@"ic_home.png"];
        [_btnHome setImage:btnImage forState:UIControlStateNormal];
       
        [_btnDimensions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnChangementMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnStatioDecoAttr  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnHome setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[_btnStatioDecoAttr layer] setBorderWidth:1.0f];
        [[_btnStatioDecoAttr layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnStatioDecoAttr layer] setCornerRadius:1.0f];
        [[_btnStatioDecoAttr layer] setBorderWidth:1.0f];
        
        [[_btnChangementMode layer] setBorderWidth:1.0f];
        [[_btnChangementMode layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnChangementMode layer] setCornerRadius:1.0f];
        [[_btnChangementMode layer] setBorderWidth:1.0f];
        
        [[_btnHome layer] setBorderWidth:1.0f];
        [[_btnHome layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnHome layer] setCornerRadius:1.0f];
        [[_btnHome layer] setBorderWidth:1.0f];
        
        [[_btnDimensions layer] setBorderWidth:1.0f];
        [[_btnDimensions layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_btnDimensions layer] setCornerRadius:1.0f];
        [[_btnDimensions layer] setBorderWidth:1.0f];
        
        /* Gestion des évènements */
        [_btnStatioDecoAttr addTarget:self.superview action:@selector(changeSatio:) forControlEvents:UIControlEventTouchUpInside];
        
        /* Gestion Pression longue retour */
        _longPressBackAccueil = [[UILongPressGestureRecognizer alloc] init];
        [_longPressBackAccueil addTarget:self action:@selector(exit:)];
        [_longPressBackAccueil setMinimumPressDuration:3];
        
        _longPressDecoAttr= [[UILongPressGestureRecognizer alloc] init];
        [_longPressDecoAttr addTarget:self action:@selector(changeDecoAttr:)];
        [_longPressDecoAttr setMinimumPressDuration:1];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToDimension:)];
        tapGesture.numberOfTapsRequired = 2;
    
        [self addGestureRecognizer:tapGesture];
        [self addGestureRecognizer:_longPressBackAccueil];
        [_btnStatioDecoAttr addGestureRecognizer:_longPressDecoAttr];
        
        _longPressHome = [[UILongPressGestureRecognizer alloc] init];
        [_longPressHome addTarget:self action:@selector(homeFunction:)];
        [_longPressHome setMinimumPressDuration:1];
        [_btnHome addGestureRecognizer:_longPressHome];
        
        [self getUserSettings];
        
        [self addSubview:_btnChangementMode];
        [self addSubview:_btnStatioDecoAttr];
        [self addSubview:_btnHome];
        [self addSubview:_btnDimensions];
        
        
    }
    
    return self;
}

- (void) setViewController:(ViewControllerManuel *) me{
    self.vc = me;
}

- (void)updateView:(CGSize)format{
    
    _tailleIcones = format.height/4;
    [_btnChangementMode setHidden:FALSE];

    /* Mise en place des labels */
    [_btnDimensions setFrame:CGRectMake(0,0,format.width,_tailleIcones)];
    [_btnChangementMode setFrame:CGRectMake(0,_tailleIcones,format.width, 2*_tailleIcones)];
    [_btnStatioDecoAttr setFrame:CGRectMake(0,_tailleIcones*2+_tailleIcones, format.width/2,_tailleIcones)];
    [_btnHome setFrame:CGRectMake(format.width/2,_tailleIcones*2+_tailleIcones,format.width/2, _tailleIcones)];
    
}

- (void)update2D3D:(CGSize)format{
    _tailleIcones = format.height/4;
    [_btnChangementMode setHidden:TRUE];
    /* Mise en place des labels */
    [_btnDimensions setFrame:CGRectMake(0,0,format.width,_tailleIcones)];
    [_btnStatioDecoAttr setFrame:CGRectMake(0,_tailleIcones, format.width/2,3*_tailleIcones)];
    [_btnHome setFrame:CGRectMake(format.width/2,_tailleIcones,format.width/2, 3*_tailleIcones)];
    
}

-(void) updateBtnHome:(NSString *)item{
    [_btnHome setTitle:item forState:UIControlStateNormal];
}

- (void) updateBtnStatioDecoAttr:(NSString*) item{
    [_btnStatioDecoAttr setTitle:item forState:UIControlStateNormal];
}

- (void) updateBtnDimensions:(NSString*) item{
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    
    
    if([item isEqualToString:@"1D"]){
        [_btnDimensions setBackgroundColor:_color1D];
        [_color1D getRed:&red green:&green blue:&blue alpha:&alpha];
    }else if([item isEqualToString:@"2D"]){
        [_btnDimensions setBackgroundColor:_color2D];
        [_color2D getRed:&red green:&green blue:&blue alpha:&alpha];
    }else if([item isEqualToString:@"3D"]){
        [_btnDimensions setBackgroundColor:_color3D];
        [_color3D getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnDimensions setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnDimensions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_btnDimensions setTitle:item forState:UIControlStateNormal];
}

- (void) updateBtnChangementMode:(NSString *)item{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    
    if([item isEqualToString:@"Axe X"]){
        [_btnChangementMode setBackgroundColor:_colorX];
        [_colorX getRed:&red green:&green blue:&blue alpha:&alpha];
    }else{
        [_btnChangementMode setBackgroundColor:_colorY];
        [_colorY getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btnChangementMode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_btnChangementMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_btnChangementMode setTitle:item forState:UIControlStateNormal];
}


-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        //Update du View Controller
        [_vc changeDecoAttr:gesture];
    }

}

- (void) exit:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        //Update du View Controller
        [_vc quitView:gesture];
    }
}

- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        //Update du View Controller
        [_vc homeFunction:gesture];
    }
}

- (void) goToDimension:(UILongPressGestureRecognizer*)gesture{
    
    if ( gesture.state == UIGestureRecognizerStateRecognized) {
        //Update du View Controller
        [_vc goToDimensionChoice:gesture];
    }
    
}




@end
