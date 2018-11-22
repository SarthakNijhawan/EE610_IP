LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

include C:/Users/wangyix/Desktop/OpenCV-android-sdk/sdk/native/jni/OpenCV.mk

LOCAL_MODULE    := mixed_sample
LOCAL_SRC_FILES := jni_part.cpp
LOCAL_LDLIBS +=  -llog -ldl -lm
LOCAL_CFLAGS    := -std=c++11

include $(BUILD_SHARED_LIBRARY)
