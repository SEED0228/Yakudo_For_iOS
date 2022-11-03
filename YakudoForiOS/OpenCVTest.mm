
#import "opencv2/opencv.hpp"
#import "opencv2/imgproc.hpp"
#import "opencv2/imgcodecs.hpp"
#import "opencv2/imgcodecs/ios.h"
#import "OpenCVTest.h"

@implementation OpenCVTest

+ (UIImage *)filteredImage:(UIImage*)image
{
    //UIImage *srcImage = [UIImage imageNamed:@"P4071145"];
    cv::Mat srcImageMat;
    cv::Mat dstImageMat;

    // UIImageからcv::Matに変換
    UIImageToMat(image, srcImageMat);
    
    // 色空間をRGBからGrayに変換
    cv::cvtColor(srcImageMat, dstImageMat, cv::COLOR_RGB2GRAY);
    
    // cv::MatをUIImageに変換
    UIImage *dstImage = MatToUIImage(dstImageMat);
    
    return dstImage;
}

@end
