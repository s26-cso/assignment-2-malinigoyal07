#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[10];
    int a, b;

    while (scanf("%s %d %d", op, &a, &b) == 3)                  // loop till EOF. loop when all 3 inputs are read 
    {
        char libname[20];
        strcpy(libname, "./lib");                          
        strcat(libname, op);
        strcat(libname, ".so");                                 // lib<op>.so

        void *fp = dlopen(libname, RTLD_LAZY);                  // load the library    
        if (!fp) {
            continue;
        }

        int (*func)(int, int);                                  // get function from library
        func = (int (*)(int, int)) dlsym(fp, op);

        if (!func) {
            dlclose(fp);
            continue;
        }

        int result = func(a, b);
        printf("%d\n", result);

        dlclose(fp);                                            // unload library due to memory constraint
    }

    return 0;
}