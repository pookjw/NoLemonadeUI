#import <Foundation/Foundation.h>
#import <substrate.h>
#import <dlfcn.h>
#include <cstring>

namespace _os_feature_enabled_impl {
    BOOL (*original)(const char *arg0, const char *arg1);
    BOOL custom(const char *arg0, const char *arg1) {
        if (!std::strcmp(arg0, "Photos") && !std::strcmp(arg1, "Lemonade")) {
            return NO;
        } else {
            return original(arg0, arg1);
        }
    }
    void hook() {
        void *handle = dlopen("/usr/lib/system/libsystem_featureflags.dylib", RTLD_NOW);
        void *symbol = dlsym(handle, "_os_feature_enabled_impl");
        MSHookFunction(symbol, reinterpret_cast<void *>(&custom), reinterpret_cast<void **>(&original));
    }
}

__attribute__((constructor)) static void init() {
    _os_feature_enabled_impl::hook();
}