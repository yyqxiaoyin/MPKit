//
//  MPKitMacro.h
//  Pods
//
//  Created by Mopon on 2017/11/3.
//

#import <UIKit/UIKit.h>
#import <pthread.h>
#import <sys/time.h>

#ifndef MPKitMacro_h
#define MPKitMacro_h


#endif /* MPKitMacro_h */

//屏幕高度
#define Screen_Height               [[UIScreen mainScreen] bounds].size.height
//屏幕宽度
#define Screen_Width                [[UIScreen mainScreen] bounds].size.width

//适配不同屏幕尺寸
#define kScreenWidthRatio           (Screen_Width / 375.0)
//iphoneX的宽度与6s相等，所以iphoneX 的高度适配比例使用6s的比例
#define kScreenHeightRatio          (Screen_Width==375 ? 1:(Screen_Height / 667.0))
#define AdaptedWidth(x)             ceilf((x) * kScreenWidthRatio)

#define AdaptedHeight(x)            ceilf((x) * kScreenHeightRatio)

#define kFontSize(R)                [UIFont systemFontOfSize:AdaptedWidth(R)]
#define kBlodFontSize(R)            [UIFont boldSystemFontOfSize:AdaptedWidth(R)]
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

//适配不同屏幕尺寸的默认字体
#define DEFAULT_FONT(size) kFontSize(size)

//是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//是否为iOS8及以上系统
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HexColor(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#ifndef YQ_SWAP // swap two value
#define YQ_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

//日志打印
#ifdef DEBUG
#   define QLog(fmt, ...) NSLog((@"%s [%d 行] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define QLog(...)
#endif

/**
 角度转角度
 
 @param degrees 角度
 @return 转换后的弧度
 */
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}


/**
 弧度转角度
 
 @param radians 弧度
 @return 转换后的角度
 */
static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

static inline NSRange NSRangeForWholeString(NSAttributedString *attString){
    
    return NSMakeRange(0, attString.string.length);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
 根据second快速生成一个 dispatch_time_t
 */
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second){
    
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second));
}

/**
 是否是在主线程
 */
static inline bool dispatch_is_main_queue(){
    
    return pthread_main_np() != 0;
}


/**
 在主线程运行(异步)
 */
static inline void dispatch_async_on_main_queue(void (^block)(void)){
    
    if (pthread_main_np()) {
        block();
    }else{
        
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 主线程运行(同步)
 */
static inline void dispatch_sync_on_main_queue(void (^block)(void)){
    
    if (pthread_main_np()) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
#pragma clang diagnostic pop

/**
 添加一个动态属性 可以给分类添加自定义属性
 
 @param association ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h> //分类需导入runtime框架
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YQSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef YQSYNTH_DYNAMIC_PROPERTY_OBJECT
#define YQSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif
