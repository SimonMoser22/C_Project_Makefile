#################################
##                             ##
##          MAKEFILE.          ##
## Created by Leon Wandruschka ##
##      Date: 17.12.2022       ##
##                             ##
#################################


#<-- VARIABLES -->#
DEBUG ?= 0
DEBUGGER ?= 0
COMPILER ?= 0
REMOVE_OBJ_FILES = 1

#<-- PATH TO DIRECTORIES -->#
INCLUDE_DIR = include
BUILD_DIR = build
SRC_DIR = src

#<-- SET COMPILERFLAGS -->#
ifeq ($(DEBUG), 1)
C_COMPILER_FLAGS = -g -O0 -Wall -Wextra -Wpedantic -Wconversion -std=c17
EXECUTABLE_NAME = mainDebug
else
C_COMPILER_FLAGS = -O3 -std=c17
EXECUTABLE_NAME = main
endif

#<-- SET DEBUGGER FLAGS -->#
ifeq ($(DEBUGGER),1)
C_DEBUGGER = gdb
else
C_DEBUGGER = lldb
endif

#<-- SET COMPILER -->#
ifeq ($(COMPILER), 1)
C_COMPILER = gcc
else
C_COMPILER = clang
endif

#<-- DELETE OBJECT FILES -->#
ifeq ($(REMOVE_OBJ_FILES), 1)
RM_OF = rm $(BUILD_DIR)/*.o
endif


C_COMPILER_CALL = $(C_COMPILER) $(C_COMPILER_FLAGS)

C_SRCS = $(wildcard $(SRC_DIR)/*.c)
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRCS))

#<-- BUILD -->#
build: $(C_OBJECTS) 
	$(C_COMPILER_CALL) $^ -o $(BUILD_DIR)/$(EXECUTABLE_NAME)
	$(RM_OF)

run: $(C_OBJECTS)
	$(C_COMPILER_CALL) $^ -o $(BUILD_DIR)/$(EXECUTABLE_NAME)
	$(RM_OF)
	@echo
	@echo Running program...
	./$(BUILD_DIR)/$(EXECUTABLE_NAME) 
	@echo "\n\n"Exit with: $$?

debug: $(C_OBJECTS)
	$(C_COMPILER) -g -O0 -Wall -Wextra -Wpedantic -Wconversion -std=c17 $^ -o $(BUILD_DIR)/$(EXECUTABLE_NAME)
	@echo
	@echo Debugging program with $(C_DEBUGGER)...
	$(C_DEBUGGER) ./$(BUILD_DIR)/$(EXECUTABLE_NAME) 


$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(C_COMPILER_CALL) -I $(INCLUDE_DIR) -c $< -o $@

#<-- CLEAN -->#
clean: 
	rm $(BUILD_DIR)/*

#<-- CLEAN OBJECT FILES -->#
cleanobj:
	$(RM_OF)

#<-- CREATE FOLDERS -->#
create-folders:
	mkdir src
	mkdir build
	mkdir include

#<-- VALGRIND (LINUX USERS) -->#
valgrind:
	@echo VALGRIND

#<-- CREATE DOXYGEN DOCUMENTATION -->#
doxygen:
	doxygen

