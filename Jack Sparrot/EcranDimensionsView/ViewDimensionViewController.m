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

/**
 * @brief Mise en place de la valeur vers la variable globale à la fenêtre
 */
-(void) endDimensionChoice:(UIButton*)send{
    
    selected = send.titleLabel.text;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
