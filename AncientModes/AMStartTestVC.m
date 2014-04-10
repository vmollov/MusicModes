//
//  AMStartTestVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 3/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStartTestVC.h"
#import "UIViewController+Parallax.h"
#import <iAd/iAd.h>

@interface AMStartTestVC ()

@end

@implementation AMStartTestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setParallaxToView:self.imgBackground];
    
    self.pkrNumQuestions.delegate = self;
    self.pkrNumQuestions.dataSource = self;
    [self.pkrNumQuestions selectRow:1 inComponent:0 animated:YES];
    
    [self.pkrNumQuestions selectRow:([[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfQuestions"]-1) inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPicker Delegates
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 100;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 45)];
    lbNumber.text = [NSString stringWithFormat:@"%i", (int)row+1];
    lbNumber.textColor = [UIColor whiteColor];
    lbNumber.textAlignment=NSTextAlignmentCenter;
    lbNumber.font = [UIFont fontWithName:@"Verdana" size:21];
    return lbNumber;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[NSUserDefaults standardUserDefaults] setInteger:(row + 1) forKey:@"numberOfQuestions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
 return 12.0f;
 }*/

#pragma mark - Navigation
-(IBAction) unwindToTestRoot:(UIStoryboardSegue *)segue{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableRemoveAds"]) {
        UIViewController *destination = [segue destinationViewController];
        destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
    }
}
@end
