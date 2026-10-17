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
TEST_CHECK := $(TESTS:.txt=.check)

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

check: $(TEST_CHECK)

$(TEST_CHECK): %.check: %.txt $(TARGET)
	@./$(TARGET) < $< > $*.actual 2>&1; \
	if ! diff -u $*.expected $*.actual; then \
		rm -f $*.actual; \
		exit 1; \
	fi
	@rm -f $*.actual	
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TEST_DIR)/*.actual