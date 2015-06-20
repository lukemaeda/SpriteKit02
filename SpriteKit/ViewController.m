//
//  ViewController.m
//  SpriteKit
//
//  Created by MAEDA HAJIME on 2014/05/14.
//  Copyright (c) 2014年 HAJIME MAEDA. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"
#import "MyScene.h"

@interface ViewController() {
    
    // MotionManagerオブジェクト
    CMMotionManager *_cmm;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // ビュー（SKView）の設定
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
    
//    CGSize gameSize;
//    gameSize.width=320;
//    
//    if (skView.frame.size.height>480){
//        //iPhone5以降
//        gameSize.height=568;
//    } else {
//        //iPhone4s
//        gameSize.height=480;
//    }
    
//    SKScene * scene = [MyScene sceneWithSize:gameSize];
    
//    NSLog(@"高さ%f", skView.frame.size.height);
    
    // シーンの作成、設定
    SKScene * scene = [MyScene sceneWithSize:
                       skView.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // シーンのオープン
    [skView presentScene:scene];
    
    // 加速度センサー開始
    [self startAccelerometer:(MyScene *)scene];

}


// 画面回転の許可
- (BOOL)shouldAutorotate
{
    return NO; // 回転許可しない
}

// 画面回転方向の設定
- (NSUInteger)supportedInterfaceOrientations
{
    // iPhoneの場合は逆回転禁止
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


// 加速度センサーの開始
- (void)startAccelerometer:(MyScene *)scene {
    
    // MotionManagerオブジェクト生成
    _cmm = [CMMotionManager new];
    //  _cmm = [[CMMotionManager alloc] init];
    
    // 設定（加速度センサー値取得間隔（秒））
    _cmm.accelerometerUpdateInterval = 0.05;
    
    // 加速度センサー受信開始
    NSOperationQueue *que = [NSOperationQueue currentQueue];
    
    // 加速度センサー受信処理
    CMAccelerometerHandler hnd =
    ^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        // センサー値の取得
        CMAcceleration ca = accelerometerData.acceleration;
        
        // 重力の変更
        [scene changeGravityWithDx:ca.x * 100
                                dy:ca.y * 100];
        
        
    };
    
    [_cmm startAccelerometerUpdatesToQueue:que
                               withHandler:hnd];
}

@end
