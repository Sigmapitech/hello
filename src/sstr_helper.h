#ifndef SSTR_HELPER_H
    #define SSTR_HELPER_H

    #define SSTR_UNPACK(s) s, SSTR_LEN(s)
    #define SSTR_LEN(s) ((sizeof(s) - 1) / sizeof(char))

#endif
