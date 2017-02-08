//
//  ViewEcranChoregraphie.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import "ViewEcranChoregraphie.h"

@implementation ViewEcranChoregraphie

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        NSLog(@"Passage ici\n");
        
        _label = [[UILabel alloc] init];
        [_label setText:@"Chorégraphie"];
        [self addSubview:_label];
        
        //Exemple de selector
        //[_btnDrone addTarget:self.superview action:@selector(goToDroneControl:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)updateView:(CGSize)format{
    
    NSLog(@"Width : %f Height : %f ",format.width,format.height);
    _tailleIcones = format.height/3 - 30;
    
    
    /* Mise en place des labels */
    /* LabelBatterySmartphone */
    [_label setHidden:NO];
    [_label setFrame:CGRectMake(0,0,_tailleIcones,_tailleIcones)];
    
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
