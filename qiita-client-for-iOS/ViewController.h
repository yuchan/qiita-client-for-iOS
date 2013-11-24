//
//  ViewController.h
//  qiita client for ios
//
//  Created by Ohashi Yusuke on 11/17/13.
//  Copyright (c) 2013 Ohashi Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *ratelimitButton;
@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UIButton *itemsButton;
@property (strong, nonatomic) IBOutlet UIButton *mystocksButton;

- (IBAction)doAuth:(id)sender;
- (IBAction)getRateLimit:(id)sender;
- (IBAction)getProfile:(id)sender;
- (IBAction)getUserInfo:(id)sender;
- (IBAction)getItems:(id)sender;
- (IBAction) getMyStocks:(id)sender;
@end
