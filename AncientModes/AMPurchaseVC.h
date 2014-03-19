//
//  AMPurchaseVC.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 3/6/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface AMPurchaseVC : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property (strong, nonatomic)SKProduct *product;
@property (strong, nonatomic)NSString *productID;

@property (strong, nonatomic) IBOutlet UILabel *lbProductTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtProductDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnBuy;
@property (strong, nonatomic) IBOutlet UIButton *btnRestore;

- (IBAction)buyProduct:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)restorePurchase:(id)sender;

-(void)getProductInfo:(UIViewController *) viewController;

@end
