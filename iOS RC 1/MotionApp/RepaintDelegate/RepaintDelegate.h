//
//  RepaintDelegate.h

#import <Foundation/Foundation.h>

@protocol RepaintDelegate <NSObject>

@optional

- (void)repaint:(NSMutableArray *)shopsData;
- (void)repaintForAddResults:(NSMutableArray *)shopsData;
- (void)repaintForSaveQuiz:(NSMutableArray *)responseData;
- (void)searchFriendsList:(NSMutableArray *)responseData;
- (void)forgetPassword:(NSMutableArray *)responseData;
- (void)updateScreen;

@end
