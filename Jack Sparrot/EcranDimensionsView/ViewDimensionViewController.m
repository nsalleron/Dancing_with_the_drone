//
//  ViewDimensionViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import "ViewDimensionViewController.h"
#import "ViewDimension.h"

@interface ViewDimensionViewController ()
@end
ViewDimension *ecranDimension;
NSString *selected;

@implementation ViewDimensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ecranDimension = [[ViewDimension alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranDimension setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView: ecranDimension];
    [self setTitle:@"Dimensions"];
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotate
{
    return YES;
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //NSLog(@"LANDSCAPE");
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //NSLog(@"PREFERRED");
    return UIInterfaceOrientationLandscapeRight;
}

-(void) endDimensionChoice:(UIButton*)send{
    
    selected = send.titleLabel.text;
    //selected = [[NSString alloc] initWithFormat:@"      %@",selected];
    //NSLog(@"%@", selected);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [ecranDimension updateView:size];
}
/**
 * @brief Appel du protocole
 */
-(void)viewWillDisappear:(BOOL)animated
{
    //Appel du protocole
    [self.delegate addItemViewController:self didFinishEnteringItem:selected];
                                                                        //^- String.
}

@end
