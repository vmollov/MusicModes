//
//  AMPurchaseVC.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 3/6/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMPurchaseVC.h"
#import "AMDataManager.h"

@implementation AMPurchaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //setup UI
    self.txtProductDescription.backgroundColor = [UIColor clearColor];
    self.btnBuy.hidden = YES;
    self.btnCancel.hidden = YES;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
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

-(void)restorePurchase {
    NSLog(@"Restore started");

    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}
-(void)dismissPurchaseScene{
    self.productName = nil;
    self.product = nil;
    self.btnBuy.hidden = YES;
    self.btnBuy.enabled = NO;
    self.btnCancel.hidden = YES;
    self.btnCancel.enabled = NO;
    self.lbProductTitle.text = nil;
    self.txtProductDescription.text = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchaseControllerFinished" object:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)getProductInfo{
    if ([SKPaymentQueue canMakePayments]){
        if(self.productName != nil){
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:[[AMDataManager getInstance] getIdForProductPurchase:self.productName]]];
            request.delegate = self;
            
            [request start];
        }else NSLog(@"No product name provided");
    }else self.txtProductDescription.text = @"Please enable In App Purchase in Settings";
}

-(void)markProductPurchased:(NSString *) productName{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[[AMDataManager getInstance] getTrackingKeyForProductPurchase:productName]];
    NSLog(@"purchased: %@ with id: %@",productName, [[AMDataManager getInstance] getIdForProductPurchase:productName]);
}
-(void)purchaseRestored:(NSString *)productID{
    NSString *productName = [[AMDataManager getInstance] getProductNameForProductId:productID];
    [self markProductPurchased:productName];
    
    NSString *messageString = [NSString stringWithFormat:@"%@ purchase has been restored.", [[AMDataManager getInstance] getProductDisplayNameForProductName:productName]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchases Restored" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Purchase Delegates
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
    
    if (products.count != 0){
        self.product = products[0];
        self.btnBuy.hidden = NO;
        self.btnBuy.enabled = YES;
        self.btnCancel.hidden = NO;
        self.btnCancel.enabled = YES;
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
                [self markProductPurchased:self.productName];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self dismissPurchaseScene];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            /*case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction Restored");
                //[self purchaseRestored];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;*/
                
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog (@"product id is %@" , productID);
        [self purchaseRestored:productID];
    }
    [self dismissPurchaseScene];
}

@end
