//
//  ViewController.m
//  qiita client for ios
//
//  Created by Ohashi Yusuke on 11/17/13.
//  Copyright (c) 2013 Ohashi Yusuke. All rights reserved.
//

#import "ViewController.h"
#import "QiitaClient.h"

#define QIITA_USERNAME @""
#define QIITA_PASSWORD  @""
#define QIITA_TEST_USERNAME @""

const AFCallbackHandler handler = ^(id JSON, NSError *error){
    if (JSON) {
        NSLog(@"%@", [JSON description]);
    }else {
        NSLog(@"%@", error.localizedDescription);
    }
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doAuth:(id)sender
{
    [QiitaClient auth:QIITA_USERNAME password:QIITA_PASSWORD callback:handler];
}

- (IBAction)getRateLimit:(id)sender
{
    [QiitaClient rate_limit:handler];
}

- (IBAction)getProfile:(id)sender
{
    [QiitaClient user:handler];
}

- (IBAction)getUserInfo:(id)sender
{
    [QiitaClient userInfo:QIITA_TEST_USERNAME callback:handler];
}

- (IBAction)getItems:(id)sender
{
    [QiitaClient userItems:QIITA_TEST_USERNAME team_url_name:nil callback:handler];
}

- (IBAction) getMyStocks:(id)sender
{
    [QiitaClient stocks:handler];
}
@end
