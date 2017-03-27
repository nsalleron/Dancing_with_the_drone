//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//


#import "ViewControllerOptions.h"
#import "ViewOptions.h"
#import "ViewCouleursController.h"


@interface ViewControllerOptions ()
@end

ViewOptions *ecranOptions;
BOOL choiceColor = false;
UIColor *saveColor;
// 1 = 1D, 2 = 2D, 3 = 3D, 4 = Axe X, 5 = Axe Y
int btnColorID = 0;


@implementation ViewControllerOptions

- (void)viewDidLoad {
    [super viewDidLoad];
    ecranOptions = [[ViewOptions alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranOptions setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView:ecranOptions];
    [[self navigationController] setNavigationBarHidden:NO];
    [self setTitle:@"Options"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goToColorChoice:(UIButton*)send{
    NSString *tmp = [[send titleLabel]text];
    if([tmp isEqualToString:@"1D"]){
        btnColorID = 1;
    }else if ([tmp isEqualToString:@"2D"]){
        btnColorID = 2;
    }else if ([tmp isEqualToString:@"3D"]){
        btnColorID = 3;
    }else if ([tmp isEqualToString:@"Axe X"]){
        btnColorID = 4;
    }else if ([tmp isEqualToString:@"Axe Y"]){
        btnColorID = 5;
    }
    
    choiceColor = true;
    ViewCouleursController *secondController = [[ViewCouleursController alloc] init];
    secondController.delegate = self;
    [[self navigationController] setNavigationBarHidden:NO];    //YES
    [self.navigationController pushViewController:secondController animated:YES];
    
}


//ROTATION

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    //if(choiceColor)
        [[self navigationController] setNavigationBarHidden:NO];
    //else
    //    [[self navigationController] setNavigationBarHidden:NO];
    
    [ecranOptions updateView:size];
}

- (void)addCouleur:(ViewDimensionViewController *)controller didFinishEnteringItem:(UIColor *)item
{
    [ecranOptions updateBtn:btnColorID color:item];
    choiceColor = false;
}

- (void) viewWillDisappear:(BOOL)animated{
    [self saveData];
}

- (void) saveData {
    
    NSArray *color = ecranOptions.getBtnColors;
    
    if ([color objectAtIndex:0] != nil) {
        NSLog(@"1D");
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[color objectAtIndex:0]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"1D"];
    }
    if ([color objectAtIndex:1] != nil) {
        NSLog(@"2D");
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[color objectAtIndex:1]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"2D"];
    }
    if ([color objectAtIndex:2] != nil) {
        NSLog(@"3D");
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[color objectAtIndex:2]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"3D"];
    }
    if ([color objectAtIndex:3] != nil) {
        NSLog(@"Axe X");
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[color objectAtIndex:3]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"Axe X"];
    }
    if ([color objectAtIndex:4] != nil) {
        NSLog(@"Axe Y");
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[color objectAtIndex:4]];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"Axe Y"];
    }
    [[NSUserDefaults standardUserDefaults] setDouble:[ecranOptions getStepperValueCoefAcce] forKey:@"Acceleration"];
    
}

/*
-(void) modeInOut:(UISwitch*) _swhInOut {
    if (_swhInOut.isset) {
        NSLog(@"bonjour");
    }else{
        NSLog(@"Au revoir");
    }
}
*/

@end
