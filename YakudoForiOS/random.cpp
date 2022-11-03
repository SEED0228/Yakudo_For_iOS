//
//  random.cpp
//  Yakudo_For_iOS
//
//  Created by SEED on 2021/04/21.
//

#include "random.h"
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int randomInt(int n) {
    srand((unsigned int)time(NULL));
    return rand() % n;
}
