#import <UIKit/UIKit.h>

@class TapLabel;

@protocol TapLabelDelegate <NSObject>

- (BOOL)label:(TapLabel*)label didBeginTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
- (BOOL)label:(TapLabel*)label didMoveTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
- (BOOL)label:(TapLabel*)label didEndTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
- (BOOL)label:(TapLabel*)label didCancelTouch:(UITouch*)touch;

@end

@interface TapLabel : UILabel

@property(nonatomic, weak) id <TapLabelDelegate> delegate;

- (void)cancelCurrentTouch;
- (CFIndex)characterIndexAtPoint:(CGPoint)point;

@end
