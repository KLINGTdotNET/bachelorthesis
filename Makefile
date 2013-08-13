#
# Makefile for Bachelorthesis
#
#	Andreas Linz -- 10INB-T
#	HTWK-Leipzig, Fakultaet IMN
#	klingt.net@googlemail.com
#
# @ supresses command output
#
# conditionals are not allowed to have a starting tab, 
# otherwise they will be sent to the shell
#
DEBUG='true'
ROOT_DIR=$(shell pwd)
BUILD_DIR=$(ROOT_DIR)/.build
BUILD_LOG_SCREEN="build_screen.log"
BUILD_LOG_PRINT="build_print.log"
OUTPUT_DIR=$(ROOT_DIR)/output
#.PHONY : clearscr clean screen print

# todo: add print target to 'all' target
all: copy_sources screen print copy_output todos

copy_sources:
	@echo "Copying sources to build folder: $(BUILD_DIR)"
	@rsync --verbose --checksum --recursive --human-readable --progress --exclude=.build --exclude=.build_scripts --exclude=output --exclude=.git --exclude=.gitignore $(ROOT_DIR)/ $(ROOT_DIR)/.build

copy_output:
	@echo "Copying generated PDFs to output folder: $(OUTPUT_DIR)"
	@cp -f $(BUILD_DIR)/*.pdf $(OUTPUT_DIR)

screen:
	@echo "Building screen version ..."
ifeq ($(DEBUG) , 'true')
	.build_scripts/screen.sh $(BUILD_DIR) $(DEBUG) > $(BUILD_LOG_SCREEN)
else
	.build_scripts/screen.sh $(BUILD_DIR) $(DEBUG) > $(BUILD_LOG_SCREEN)
endif

print:
	@echo "Building print version ..."
ifeq ($(DEBUG) , 'true')
	.build_scripts/print.sh $(BUILD_DIR) $(DEBUG) > $(BUILD_LOG_PRINT)
else
	.build_scripts/print.sh $(BUILD_DIR) $(DEBUG) > $(BUILD_LOG_PRINT)
endif

clean_conflicts:
	@find $(ROOT_DIR) -name '*in Konflikt stehende*' -delete
	@find $(ROOT_DIR) -name '*conflicted copy*' -delete

clean: clean_conflicts
	@echo "I will clean up this mess ..."
#	@find $(ROOT_DIR) -regex '.*~' -delete
# $ has to be escaped to $$
	@cd $(BUILD_DIR); rm --recursive --verbose *

clean_all: clean
	@rm $(OUTPUT_DIR)/*

clearscreen:
	clear

todos:
	@echo -e "\n--------------------- What you have to do --------------------- \n"
	@./todos.sh
