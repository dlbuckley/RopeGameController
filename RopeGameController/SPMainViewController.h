//
//  SPMainViewController.h
//  RopeGameController
//
//  Created by Dale Buckley on 19/09/2013.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;

NS_ENUM(NSUInteger, SPOperationType) {
    SPOperationPlayerConnected,
    SPOperationStartGame,
    SPOperationGameProgress,
    SPOperationUserProgress,
    SPOperationEndGame,
};

@interface SPMainViewController : UIViewController <MCSessionDelegate>

@end
