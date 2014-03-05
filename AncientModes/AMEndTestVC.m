//
//  AMEndTestVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 3/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMEndTestVC.h"

@interface AMEndTestVC ()

@end

@implementation AMEndTestVC

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
    self.summaryTable = [self.childViewControllers lastObject];

    self.summaryTable.lbQuestions.text = [NSString stringWithFormat:@"%i",self.questions];
    self.summaryTable.lbAnswered.text = [NSString stringWithFormat:@"%i", self.test.correctAnswersCount];
    self.summaryTable.lbHints.text = [NSString stringWithFormat:@"%i", self.test.hintsCount];
    self.lbFinalScore.text = [NSString stringWithFormat:@"%.f%%", self.test.getRunningScore];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
