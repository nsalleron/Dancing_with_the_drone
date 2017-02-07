//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import "ViewControllerDrone.h"
#import "ViewControllerManuel.h"

#import "ViewControllerAcceuil.h"


#import "ViewManuel.h"
#import "ViewEcranAccueil.h"


@interface ViewControllerDrone ()

@end
UIView *ecranDrone;

@implementation ViewControllerDrone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self setView: ecranDrone];
    [self setTitle:@"Drone"];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    //On place les views
    UIViewController *page1 = [self viewControllerAtIndex:0];
    //UIViewController *page2 = [self viewControllerAtIndex:1];
    //UIViewController *page3 = [self viewControllerAtIndex:2];
    
    
    
    // load the view controllers in our pages array
    NSArray *pages = [[NSArray alloc] initWithObjects:page1, nil];
    
    
    //NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
   
    
    [self.pageController setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //[self.pageController setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSLog(@"Passage pageViewController");
    
    NSUInteger index = [(ViewControllerManuel *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
   
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSLog(@"Passage pageViewController2");
    
    NSUInteger index = [(ViewControllerManuel *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIViewController *childViewController;
    childViewController = [[ViewControllerManuel alloc] init];
    
    NSLog(@"Page :  %ld",index);
    
    switch (index) {
        case 0:
            childViewController = [[ViewControllerManuel alloc] init];
            
            ecranDrone = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
            [ecranDrone setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
            
            [childViewController setView:ecranDrone];
             ((ViewControllerManuel*)childViewController).index = index;
            break;
            
        case 1:
            childViewController = [[ViewControllerAccueil alloc] init];
            
            ecranDrone = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
            [ecranDrone setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
            
            [childViewController setView:ecranDrone];
            ((ViewControllerAccueil*)childViewController).index = 1;
            
            
            
            // LE BREAK LAAAA
            break;
            
        case 2:
            childViewController = [[ViewControllerManuel alloc] init];
           
            ecranDrone = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
            [ecranDrone setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
            
            [childViewController setView:ecranDrone];
            
             ((ViewControllerManuel*)childViewController).index = index;
            break;
        default:
            childViewController = nil;
    }
    
    
    return childViewController;
    
}



@end
