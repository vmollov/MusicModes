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
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //setup UI
    self.txtProductDescription.backgroundColor = [UIColor clearColor];
    self.btnBuy.hidden = YES;
    self.btnCancel.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)buyProduct:(id)sender {
    self.txtProductDescription.text = @"";
    self.lbProductTitle.text = @"Processing...";
    
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)cancel:(id)sender {
    [self dismissPurchaseScene];
}

-(void)restorePurchase {
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}
-(void)dismissPurchaseScene{
    self.productName = nil;
    self.product = nil;
    self.btnBuy.hidden = YES;
    self.btnBuy.enabled = NO;
    self.btnCancel.hidden = NO;
    self.btnCancel.enabled = YES;
    //self.btnCancel.titleLabel.text = @"Done";
    self.lbProductTitle.text = nil;
    self.txtProductDescription.text = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchaseControllerFinished" object:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)getProductInfo{
    NSLog(@"getting info for: %@", [[AMDataManager getInstance] getIdForProductPurchase:self.productName]);
    if ([SKPaymentQueue canMakePayments]){
        if(self.productName != nil){
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:[[AMDataManager getInstance] getIdForProductPurchase:self.productName]]];
            request.delegate = self;
            
            [request start];
        }else NSLog(@"No product name provided");
    }else self.txtProductDescription.text = @"Please enable In App Purchase in Settings";
}

-(void)markPurchasedProductID:(NSString *) productID{
    if (productID == nil) return;
    
    NSString *productName =[[AMDataManager getInstance] getProductNameForProductId:productID];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[[AMDataManager getInstance] getTrackingKeyForProductPurchase:productName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"purchased: %@ with id: %@",productName, [[AMDataManager getInstance] getIdForProductPurchase:productName]);
}
-(void)restorePurchaseForProductID:(NSString *)productID{
    NSString *productName = [[AMDataManager getInstance] getProductNameForProductId:productID];
    [self markPurchasedProductID:productID];
    
    NSString *messageString = [NSString stringWithFormat:@"%@ purchase has been restored.", [[AMDataManager getInstance] getProductDisplayNameForProductName:productName]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchases Restored" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)processPurchasesFromArray:(NSArray *)purchases{
    for(NSString *productID in purchases) [self markPurchasedProductID:productID];
    [self dismissPurchaseScene];
}
-(void)processRestoresFromArray:(NSArray *) purchases{
    for(NSString *productID in purchases) [self restorePurchaseForProductID:productID];
    [self dismissPurchaseScene];
}
-(void)processNoRestoresFound{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Purchases" message:@"There are no purchases to restore" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self dismissPurchaseScene];
}
-(void)failTransaction{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Something went wrong.  Please try again.  Sorry for the inconvenience!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self dismissPurchaseScene];
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
    NSMutableArray *purchasedTransactions = [[NSMutableArray alloc] init];
    NSMutableArray *restoredTransactions = [[NSMutableArray alloc]init];
    
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"statePurchased: %@ id: %@", transaction, transaction.originalTransaction.payment.productIdentifier);
                if(transaction.originalTransaction.payment.productIdentifier != nil)[purchasedTransactions addObject:transaction.originalTransaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"stateFailed");
                NSLog(@"Failed for id: %@ Error: %@", transaction.originalTransaction.payment.productIdentifier, transaction.error.localizedDescription);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self failTransaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"stateRestored");
                [restoredTransactions addObject:transaction.originalTransaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
    if(purchasedTransactions.count > 0)[self processPurchasesFromArray:purchasedTransactions];
    if(restoredTransactions.count > 0)[self processRestoresFromArray:restoredTransactions];
}

/*- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    if(queue.transactions.count == 0) [self processNoRestoresFound];
    
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    //for (SKPaymentTransaction *transaction in queue.transactions){
        
    //}
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"Error when purchasing: %@",error);
    
}*/

@end
