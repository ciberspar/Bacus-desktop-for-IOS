
#import <UIKit/UIKit.h>
#import "Core/BDWindowManager.h"

%ctor {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BDWindowManager start];
        });
    }
}
