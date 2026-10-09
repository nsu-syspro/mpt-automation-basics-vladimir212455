CC        := gcc
SRC_DIR   := src
BUILD_DIR := build
OBJ_DIR   := $(BUILD_DIR)/obj
TEST_DIR  := test
CONFIG    := config.json
NAME      := $(shell jq -r .name $(CONFIG))
VERSION   := $(shell jq -r .version $(CONFIG))
TARGET    := $(BUILD_DIR)/$(NAME)
CFLAGS    := -Wall -Wextra -Werror -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'
SRCS      := $(wildcard $(SRC_DIR)/*.c)
TESTS     := $(wildcard $(TEST_DIR)/*.txt)
OBJS      := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(CONFIG) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)
	
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

check: $(TARGET)
	@for file in $(TESTS); do \
		exp_file="$${file%.txt}.expected"; \
		./$(TARGET) < "$$file" > /tmp/tmp_out 2>&1; \
		if ! diff -u "$$exp_file" /tmp/tmp_out; then \
			rm -f /tmp/tmp_out; \
			exit 1; \
		fi; \
	done
	@rm -f /tmp/tmp_out

clean:
	rm -rf $(BUILD_DIR)
