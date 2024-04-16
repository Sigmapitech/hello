.POSIX:

BUILD_DIR := .build
OUT := hello

CC := gcc

CFLAGS := -pedantic
CFLAGS += -Wp,-U_FORTIFY_SOURCE
CFLAGS += -Wformat=2

CFLAGS += -MMD -MP
CFLAGS += -fanalyzer
CFLAGS += -fno-builtin
CFLAGS += -pipe

CFLAGS += -O2 -march=native -mtune=native

CFLAGS += -Wall
CFLAGS += -Wcast-qual
CFLAGS += -Wconversion
CFLAGS += -Wdisabled-optimization
CFLAGS += -Wduplicated-branches
CFLAGS += -Wduplicated-cond
CFLAGS += -Werror=return-type
CFLAGS += -Werror=vla-larger-than=0
CFLAGS += -Wextra
CFLAGS += -Winit-self
CFLAGS += -Winline
CFLAGS += -Wlogical-op
CFLAGS += -Wmissing-prototypes
CFLAGS += -Wredundant-decls
CFLAGS += -Wshadow
CFLAGS += -Wstrict-prototypes
CFLAGS += -Wsuggest-attribute=pure
CFLAGS += -Wsuggest-attribute=const
CFLAGS += -Wundef
CFLAGS += -Wunreachable-code
CFLAGS += -Wwrite-strings

CFLAGS += -iquote src

LDFLAGS := -fwhole-program -flto

VPATH += src
SRC := main.c

vpath %.c $(VPATH)

OBJ := $(SRC:%.c=$(BUILD_DIR)/release/%.o)

.PHONY: all
all: $(OUT)

$(OUT): $(OBJ)
	@ mkdir -p $(dir $@)
	$Q $(CC) -o $@ $(OBJ) $(CFLAGS) $(LDLIBS) $(LDFLAGS)
	@ $(LOG_TIME) "LD $(C_GREEN) $@ $(C_RESET)"

$(BUILD_DIR)/release/%.o: %.c
	@ mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -o $@ -c $< || exit 1
	@ $(LOG_TIME) "CC $(C_PURPLE) $(notdir $@) $(C_RESET)"

.PHONY: clean
clean:
	$(RM) $(OBJ)
	@ $(LOG_TIME) $@

.PHONY: fclean
fclean: clean
	$(RM) -r $(BUILD_DIR) $(OUT)
	@ $(LOG_TIME) $@

.PHONY: re
.NOTPARALLEL: re
re: fclean all

ifneq ($(shell command -v tput),)
  ifneq ($(shell tput colors),0)

C_RESET := \033[00m
C_BOLD := \e[1m
C_RED := \e[31m
C_GREEN := \e[32m
C_YELLOW := \e[33m
C_BLUE := \e[34m
C_PURPLE := \e[35m
C_CYAN := \e[36m

C_BEGIN := \033[A

  endif
endif

NOW = $(shell date +%s%3N)
STIME := $(call NOW)
TIME_NS = $(shell expr $(call NOW) - $(STIME))
TIME_MS = $(shell expr $(call TIME_NS))

BOXIFY = "[$(C_BLUE)$(1)$(C_RESET)] $(2)"

ifneq ($(shell command -v printf),)
  LOG_TIME = printf $(call BOXIFY, %6s , %b\n) "$(call TIME_MS)"
else
  LOG_TIME = echo -e $(call BOXIFY, $(call TIME_MS) ,)
endif
