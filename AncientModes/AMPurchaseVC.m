//
//  AMPurchaseVC.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 3/6/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMPurchaseVC.h"

@implementation AMPurchaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.txtProductDescription.backgroundColor = [UIColor clearColor];
    self.btnBuy.hidden = YES;
    self.btnRestore.hidden = YES;
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)buyProduct:(id)sender {
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)cancel:(id)sender {
    [self dismissPurchaseScene];
}

- (IBAction)restorePurchase:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)dismissPurchaseScene{
    self.product = nil;
    self.btnBuy.hidden = YES;
    self.btnBuy.enabled = NO;
    self.btnRestore.hidden = YES;
    self.btnRestore.enabled = NO;
    self.lbProductTitle.text = nil;
    self.txtProductDescription.text = nil;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)getProductInfo:(UIViewController *)viewController{
    if ([SKPaymentQueue canMakePayments]){
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:self.productID]];
        request.delegate = self;
        
        [request start];
    }else self.txtProductDescription.text = @"Please enable In App Purchase in Settings";
}

-(void)markProductPurchased{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.productKey];
    [self dismissPurchaseScene];
}
-(void)purchaseRestored{
    [self markProductPurchased];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchases Restored" message:@"Your purchases have been restored" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0)
}*/

#pragma mark - Purchase Delegates
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
    
    if (products.count != 0){
        self.product = products[0];
        self.btnBuy.hidden = NO;
        self.btnBuy.enabled = YES;
        self.btnRestore.hidden = NO;
        self.btnRestore.enabled = YES;
        self.lbProductTitle.text = self.product.localizedTitle;
        self.txtProductDescription.text = self.product.localizedDescription;
        self.txtProductDescription.textColor = [UIColor whiteColor];
        self.txtProductDescription.font = [UIFont fontWithName:@"Verdana" size:18];
        self.txtProductDescription.textAlignment = NSTextAlignmentCenter;
        [self.view bringSubviewToFront:self.txtProductDescription];
    }else{
        self.lbProductTitle.text = @"Product not found";
    }
    products = response.invalidProductIdentifiers;
    for (SKProduct *product in products) NSLog(@"Product not found: %@", product);
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self markProductPurchased];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction Restored");
                [self purchaseRestored];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }

}
@end
