//
//  InputError.h
//  TOTextInputChecker
//
//  Created by Tony on 13-11-18.
//  Copyright (c) 2013年 SDNX. All rights reserved.
//

#ifndef mbank_InputError_h
#define mbank_InputError_h

enum InputCheckError {
    InputCheckErrorNone = 0,
    InputCheckErrorNull = 1,
    InputCheckErrorShot = 2,
    InputCheckErrorSmall = 3,
    InputCheckErrorOnlyLength = 4,
    InputCheckErrorRegex = 5,
};

#endif
