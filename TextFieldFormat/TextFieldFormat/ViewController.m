//
//  ViewController.m
//  TextFieldFormat
//
//  Created by 子瞻 on 2017/1/3.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+customFormat.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *myTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [self.myTextField setBorderStyle:UITextBorderStyleLine];
    
    //  set bankcard format:
    [self.myTextField setHasSpaceEveryFourDigits];
    
    [self.view addSubview:self.myTextField];
    [self.myTextField setCenter:self.view.center];
}


@end
