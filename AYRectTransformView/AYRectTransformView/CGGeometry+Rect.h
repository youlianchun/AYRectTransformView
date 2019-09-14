//
//  CGGeometry+Rect.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/7.
//

#import <UIKit/UIKit.h>

#pragma mark - CGAlgorithm
//角度->弧度
CG_INLINE CGFloat
angle2radian(CGFloat angle)
{
    return (M_PI * (angle) / 180.0);
}

//弧度->角度
CG_INLINE CGFloat
radian2angle(CGFloat radian)
{
    return (radian * 180.0) / M_PI;
}

//精度取整
CG_INLINE CGFloat
truncPrecision(CGFloat value)
{
    return value;
    static float p = 0.0001;//精度值
    int ia = (int)value;
    if (ia > 0) {
        if (value - p < ia) return ia;
        if (value + p > ia) return ia + 1;
        return value;
    }
    else {
        if (value + p > ia) return ia;
        if (value - p < ia) return ia - 1;
        return value;
    }
}

//点绕锚旋转到新点的弧度
CG_INLINE CGFloat
CGPointRadian(CGPoint anchor, CGPoint from, CGPoint to)
{
    return atan2f(to.y - anchor.y, to.x - anchor.x) - atan2f(from.y - anchor.y, from.x - anchor.x);
}

//点绕锚点旋转一定弧度后的新点
CG_INLINE CGPoint
CGPointRotateRadian(CGPoint anchor, CGPoint from, CGFloat toRadian)
{
    double sa = sin(toRadian);
    double ca = cos(toRadian);
    CGPoint point;
    point.x = anchor.x + ((from.x - anchor.x) * ca - (from.y - anchor.y) * sa);
    point.y = anchor.y + ((from.x - anchor.x) * sa + (from.y - anchor.y) * ca);
    return point;
}

//点绕锚点旋转到新点的夹角
//CG_INLINE CGFloat
//CGPointAngle(CGPoint anchor, CGPoint from, CGPoint to)
//{
//    CGFloat radian = CGPointRadian(anchor, from, to);
//    return radian2angle(radian);
//}

//点绕锚点选装一定角度后的新点
//CG_INLINE CGPoint
//CGPointRotateAngle(CGPoint anchor, CGPoint from, CGFloat toAngle)
//{
//    CGFloat radian = angle2radian(toAngle);
//    return CGPointRotateRadian(anchor, from, radian);
//}

//两点之间的距离
CG_INLINE CGFloat
CGPointDistance(CGPoint pt0, CGPoint pt1)
{
    return sqrtf(powf((pt0.x - pt1.x), 2) + powf((pt0.y - pt1.y), 2));
}

//两点之间中心点
CG_INLINE CGPoint
CGPointCenter(CGPoint pt0, CGPoint pt1)
{
    return CGPointMake((pt0.x + pt1.x)/2, (pt0.y + pt1.y)/2);
}

//点距离锚点比例（缩放值）
CG_INLINE CGFloat
CGPointScale(CGPoint anchor, CGPoint from, CGPoint to)
{
    return CGPointDistance(to, anchor) / CGPointDistance(from, anchor);
}

//点距离锚点缩放后的新点
CG_INLINE CGPoint
CGScalePoint(CGPoint anchor, CGPoint from, CGFloat toScale)
{
    CGPoint point;
    point.x = toScale * (from.x - anchor.x) + anchor.x;
    point.y = toScale * (from.y - anchor.y) + anchor.y;
    return point;
}

//点根据锚点进行缩放旋转（弧度）得到的新点
CG_INLINE CGPoint
CGTransformPoint(CGPoint anchor, CGPoint from, CGFloat toRadian, CGFloat toScale)
{
    return CGScalePoint(anchor, CGPointRotateRadian(anchor, from, toRadian), toScale);
}

//点位置调整
CG_INLINE CGPoint
CGOffsetPoint(CGPoint point, CGFloat x, CGFloat y)
{
    point.x = point.x + x;
    point.y = point.y + y;
    return point;
}

//点误差 to-from
CG_INLINE CGSize
CGPointOffset(CGPoint from, CGPoint to)
{
    return CGSizeMake(to.x - from.x, to.y - from.y);
}

//平行点
CG_INLINE CGPoint
CGParallelPoint(CGPoint point, CGPoint from, CGPoint to)
{
    CGFloat ofX = to.x - from.x;
    CGFloat ofY = to.y - from.y;
    return CGOffsetPoint(point, ofX, ofY);
}

CG_INLINE CGSize
CGSizeScale(CGSize size, CGFloat scale)
{
    size.width *= scale;
    size.height *= scale;
    return size;
}

//////////////////////////////////////////////////////////////////////////////
/****************************************************************************/
//////////////////////////////////////////////////////////////////////////////

#pragma mark - CustomRect

typedef struct CGCenterRect {
    CGPoint center;
    CGSize size;
} CGCenterRect;

typedef struct CGRotateRect {
    CGCenterRect centerRect;
    CGFloat radian;
} CGRotateRect;

typedef struct CGPathRect {
    CGPoint lt; //left top
    CGPoint lb; //left bottom
    CGPoint rb; //right bottom
    CGPoint rt; //right top
} CGPathRect;


CG_INLINE CGCenterRect
CGCenterRectMark(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGCenterRect rect;
    rect.center.x = x;
    rect.center.y = y;
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}
#define CGCenterRectZero CGCenterRectMark(0, 0, 0, 0)

CG_INLINE CGRotateRect
CGRotateRectMark(CGFloat x, CGFloat y, CGFloat width, CGFloat height, CGFloat radian)
{
    CGRotateRect rect;
    rect.centerRect = CGCenterRectMark(x, y, width, height);
    rect.radian = radian;
    return rect;
}
#define CGRotateRectZero CGRotateRectMark(0, 0, 0, 0, 0)


CG_INLINE CGPathRect
CGPathRectMark(CGPoint lt, CGPoint lb, CGPoint rb, CGPoint rt)
{
    CGPathRect rect;
    rect.lt = lt;
    rect.lb = lb;
    rect.rb = rb;
    rect.rt = rt;
    return rect;
}
#define CGPathRectZero CGPathRectMark(CGPointZero, CGPointZero, CGPointZero, CGPointZero)

CG_INLINE CGPoint
CGCenterRectOrign(CGCenterRect rect)
{
    CGSize size = rect.size;
    return CGPointMake(rect.center.x - size.width / 2.0, rect.center.y - size.height / 2.0);
}

CG_INLINE CGRect
CGCenterRect2CGRect(CGCenterRect centerRect)
{
    CGRect rect = CGRectZero;
    rect.origin = CGCenterRectOrign(centerRect);
    rect.size = centerRect.size;
    return rect;
}

CG_INLINE CGRotateRect
CGPathRect2CGRotateRect(CGPathRect path)
{
    CGFloat width = CGPointDistance(path.lt, path.rt);
    CGFloat height = CGPointDistance(path.lt, path.lb);
    CGPoint center = CGPointCenter(path.lt, path.rb);
    CGCenterRect centerRect = CGCenterRectMark(center.x, center.y, width, height);
    CGPoint orign = CGCenterRectOrign(centerRect);
    CGRotateRect rotateRect = CGRotateRectZero;
    rotateRect.centerRect = centerRect;
    rotateRect.radian = -CGPointRadian(centerRect.center, path.lt, orign);
    return rotateRect;
}

CG_INLINE CGPathRect
CGRotateRect2CGPathRect(CGRotateRect rect)
{
    CGPathRect path = CGPathRectZero;
    path.lt = CGCenterRectOrign(rect.centerRect);
    path.lb = CGPointMake(path.lt.x, path.lt.y + rect.centerRect.size.height);
    path.rb = CGPointMake(path.lt.x + rect.centerRect.size.width, path.lt.y + rect.centerRect.size.height);
    path.rt = CGPointMake(path.lt.x + rect.centerRect.size.width, path.lt.y);
    CGPoint anchor = rect.centerRect.center;
    path.lt = CGPointRotateRadian(anchor, path.lt, rect.radian);
    path.lb = CGPointRotateRadian(anchor, path.lb, rect.radian);
    path.rb = CGPointRotateRadian(anchor, path.rb, rect.radian);
    path.rt = CGPointRotateRadian(anchor, path.rt, rect.radian);
    return path;
}

CG_INLINE BOOL
CGPathRectContainsPoint(CGPathRect pathRect, CGPoint point)
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, pathRect.lt.x, pathRect.lt.y);
    CGPathAddLineToPoint(pathRef, NULL, pathRect.lb.x, pathRect.lb.y);
    CGPathAddLineToPoint(pathRef, NULL, pathRect.rb.x, pathRect.rb.y);
    CGPathAddLineToPoint(pathRef, NULL, pathRect.rt.x, pathRect.rt.y);
    CGPathCloseSubpath(pathRef);
    BOOL isContains = CGPathContainsPoint(pathRef, nil, point, false);
    CGPathRelease(pathRef);
    return isContains;
}

CG_INLINE BOOL
CGRotateRectContainsPoint(CGRotateRect rotateRect, CGPoint point)
{
    return CGPathRectContainsPoint(CGRotateRect2CGPathRect(rotateRect), point);
}

CG_INLINE CGPathRect
CGRect2CGPathRect(CGRect rect)
{
    CGPathRect path = CGPathRectZero;
    path.lt = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    path.lb = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    path.rb = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    path.rt = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    return path;
}

CG_INLINE CGCenterRect
CGCenterRectScale(CGCenterRect rect, CGFloat scale)
{
    rect.size = CGSizeScale(rect.size, scale);
    return rect;
}

CG_INLINE CGCenterRect
CGCenterRectTranslation(CGCenterRect rect, CGPoint translation)
{
    rect.center.x += translation.x;
    rect.center.y += translation.y;
    return rect;
}


CG_INLINE CGRotateRect
CGRotateRectScale(CGRotateRect rect, CGFloat scale)
{
    rect.centerRect = CGCenterRectScale(rect.centerRect, scale);
    return rect;
}

CG_INLINE CGRotateRect
CGRotateRectRotation(CGRotateRect rect, CGFloat radian)
{
    rect.radian += radian;
    return rect;
}

CG_INLINE CGRotateRect
CGRotateRectTranslation(CGRotateRect rect, CGPoint translation)
{
    rect.centerRect = CGCenterRectTranslation(rect.centerRect, translation);
    return rect;
}

CG_INLINE BOOL
CGCenterRectIsZero(CGCenterRect rect)
{
    return rect.size.width == 0 || rect.size.height == 0;
}

CG_INLINE BOOL
CGRotateRectIsZero(CGRotateRect rect)
{
    return CGCenterRectIsZero(rect.centerRect);
}

CG_INLINE CGPoint
CGPathRectCenter(CGPathRect rect) {
    return CGPointCenter(rect.lt, rect.rb);
}

CG_INLINE CGPathRect
CGPathRectExp(CGPathRect rect, CGFloat dist)
{
    if (dist == 0) return rect;
    CGRotateRect rotateRect = CGPathRect2CGRotateRect(rect);
    CGFloat offset = dist + dist;
    rotateRect.centerRect.size.height += offset;
    rotateRect.centerRect.size.width += offset;
    return CGRotateRect2CGPathRect(rotateRect);
}
