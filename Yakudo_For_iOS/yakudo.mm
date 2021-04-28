//
//  yakudo.cpp
//  Yakudo_For_iOS
//
//  Created by 多根直輝 on 2021/04/21.
//
#import "opencv2/opencv.hpp"
#import "opencv2/imgproc.hpp"
#import "opencv2/imgcodecs.hpp"
#import "opencv2/imgcodecs/ios.h"
#import "Yakudo.h"
#import "random.h"

@implementation Yakudo

+ (UIImage *)yakudo:(UIImage*)image
{
    cv::Mat srcImageMat;
    cv::Mat subImageMat;
    double alpha, beta;
    int n = 4;
    int width, height, x0 = randomInt(n), x1 = randomInt(n), y0 = randomInt(n), y1 = randomInt(n);

    // UIImageからcv::Matに変換
    UIImageToMat(image, srcImageMat);
    subImageMat = srcImageMat;
    width = (int)srcImageMat.size().width;
    height = (int)srcImageMat.size().height;
    cv::Rect rect = cv::Rect((width / 250) + x0, (height / 250) + y0, (width * 248 / 250) - x1, (height * 248 / 250) - y1);
    for(int i = 0;i<21;i++) {
        alpha = 1.0 / (i + 2.0);
        beta = 1.0 - alpha;
        subImageMat = cv::Mat(subImageMat, rect);
        cv::resize(subImageMat, subImageMat, srcImageMat.size());
        cv::addWeighted(srcImageMat, beta, subImageMat, alpha, 0.0, srcImageMat);
    }
    
    // cv::MatをUIImageに変換
    UIImage *yakudoImage = MatToUIImage(srcImageMat);
    
    return yakudoImage;
}

@end

