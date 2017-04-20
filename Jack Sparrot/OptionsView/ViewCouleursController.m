//
//  ViewCouleursController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import "ViewCouleursController.h"
#import "ViewCouleurs.h"

@interface ViewCouleursController ()
@end

ViewCouleurs *ecranCouleurs;
UIColor *valCouleur=nil;
//NSString *selected;

@implementation ViewCouleursController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ecranCouleurs = [[ViewCouleurs alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranCouleurs setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView: ecranCouleurs];
    [self setTitle:@"Couleurs"];
    
    
}

/**
 * @brief fin du choix de couleur; retour à la vue précédente avec la couleur.
 */
-(void) endColorChoice:(UIButton*)send{
    valCouleur = send.backgroundColor;
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecranCouleurs updateView:size];
}

/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)prefersStatusBarHidden {
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


/**
 * @brief couleur vers delegate
 */
- (void) viewWillDisappear:(BOOL)animated{
    [self.delegate addCouleur:self didFinishEnteringItem:valCouleur];
    valCouleur = nil;
}



@end

