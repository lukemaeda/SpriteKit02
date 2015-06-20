//
//  MyScene.m
//  SpriteKit
//
//  Created by MAEDA HAJIME on 2014/05/14.
//  Copyright (c) 2014年 HAJIME MAEDA. All rights reserved.
//

#import "MyScene.h"

@interface MyScene () <SKPhysicsContactDelegate>

@end

@implementation MyScene

// イニシャライザ
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15
                                               green:0.15
                                                blue:0.3
                                               alpha:1.0];
        
        // 物理枠の設定（シーンの物性）
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // 物理空間の重力 上に上昇
        //self.physicsWorld.gravity = CGVectorMake(0.0, -9.8); // -9.8 下 9.8 上
        
        
        // デリゲート設定
        self.physicsWorld.contactDelegate = self;
        
        
    
        // ノードの追加（ラベル）
        {
            SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            
            //　Hello, World!
            myLabel.text = @"Hello, World!";
            myLabel.fontSize = 10;
            myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
            
            // 山小屋表示
            SKSpriteNode* iv;
            iv = [SKSpriteNode spriteNodeWithImageNamed:@"images.png"];
            
            iv.position = CGPointMake(160, 90);
            [self addChild:iv];
            
            // 物性（剛性）の設定
            myLabel.physicsBody =
                [SKPhysicsBody bodyWithRectangleOfSize:myLabel.frame.size];
            
            // 重力の影響の設定
            myLabel.physicsBody.dynamic = NO;
            
            [self addChild:myLabel];
            
        }
        
        // ノードの追加（エミッター）放射する
        {
            // パーティクルの参照
            NSBundle *bnd = [NSBundle mainBundle];
            NSString *pth = [bnd pathForResource:@"ParticleSnow" ofType:@"sks"];
            
            SKEmitterNode *nod = [NSKeyedUnarchiver unarchiveObjectWithFile:pth];
            
            nod.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMaxY(self.frame));
            [self addChild:nod];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        // タッチ位置の取得
        CGPoint location = [touch locationInNode:self];
        
        // ノードの追加（スプライト）
        {
            // ノードオブジェクト追加
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
            sprite.position = location;
            
            // サイズの倍率
            sprite.xScale = 0.2;
            sprite.yScale = 0.2;
            
            // アンカーポイントの設定（いかり）
            sprite.anchorPoint = CGPointMake(0.5, 0.3);
            
            // 物性（剛性）の設定
            sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width / 2 * 0.8];
            
            // 衝突テストビットマップの設定
            sprite.physicsBody.contactTestBitMask = 1;
            
            [self addChild:sprite];
            
            // アクション設定（回転）
//            SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//            [sprite runAction:[SKAction repeatActionForever:action]];
            
            
        }
        
    }
}

// FPS(Frame Per Second)毎に実行
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - SKPhysicsContactDelegate Method

// 衝突終了後
-(void)didEndContact:(SKPhysicsContact *)contact {
    
    // 音の再生
    SKAction *act = [SKAction playSoundFileNamed:@"middle_punch2.mp3"
                               waitForCompletion:YES];
    
    
    [self runAction:act];
    
    // ノードの追加（エミッター）放射する
    {
        // パーティクルの参照
        NSBundle *bnd = [NSBundle mainBundle];
        NSString *pth = [bnd pathForResource:@"ParticleSpark" ofType:@"sks"];
        
        SKEmitterNode *nod = [NSKeyedUnarchiver unarchiveObjectWithFile:pth];
        
        nod.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMaxY(self.frame));
        
        // パーティクル数
        nod.position = contact.contactPoint;
        
        nod.numParticlesToEmit = 10;
        
        [self addChild:nod];
    }
}
#pragma mark - Own Method
    
// 重力の変更
-(void)changeGravityWithDx:(CGFloat)dx
                        dy:(CGFloat)dy {
        // 物理空間の重力 上に上昇
        self.physicsWorld.gravity = CGVectorMake(dx, dy); // -9.8 下 9.8 上
        
    }

@end
