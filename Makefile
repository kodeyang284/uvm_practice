# Makefile for UVM PRACTICE

export UVMSZ_HOME = $(HOME)/Public/uvm_practice

CHAPTER = ch4
SECTION = section4.2/4.2.1
SECTION = prac
CHDIR   = $(addprefix $(UVMSZ_HOME)/src/, $(CHAPTER))
SECTDIR = $(addprefix $(CHDIR)/, $(SECTION))
include $(CHDIR)/$(CHAPTER).mk

## something to check
ifeq ($(flavor TOP), undefined)
  $(error Need a top module)
endif

ifeq ($(flavor SRCS), undefined)
  $(error Nothing to build)
endif

ifeq ($(flavor INC_PATH), undefined)
  $(error Need include path)
endif

## workdir and simv file
WORKDIR    = $(shell pwd)
DST_DIR    = $(WORKDIR)/build
SIMV       = $(DST_DIR)/simv
$(shell mkdir -p $(DST_DIR))

## uvm libs
UVM_HOME   = $(UVMSZ_HOME)/uvm-1.1d
UVMLIBS    = +incdir+$(UVM_HOME)/src \
				     $(UVM_HOME)/src/uvm_pkg.sv \
				     $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS

## build flags and options
TIMESCALE  = -timescale=1ns/1ps
VCS        = vcs
INCDIR    += $(addprefix +incdir, $(INC_PATH))
DEFINES   += +UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
#VFLAGS    +=-debug_acc+all -debug_region+cell+encrypt
VFLAGS    += $(addprefix +define, $(DEFINES))
VFLAGS    += -sverilog -l vcs.log -q \
             $(UVMLIBS) $(TIMESCALE) $(INCDIR)


## runtime flags and defines
TESTNAME   = my_case0
VERBOSE    = UVM_MEDIUM
#RUNOPTS   += +UVM_CONFIG_DB_TRACE
RUNOPTS   += $(addprefix +UVM_TESTNAME=, $(TESTNAME))
#RUNOPTS   += $(addprefix +UVM_VERBOSITY=, $(VERBOSE))
RUNOPTS   += -k $(DST_DIR)/ucli.key -l $(DST_DIR)/simv.log

## wave flags and options(verdi)
WAVEFILE   = $(DST_DIR)/a.fsdb
WAVETOOL   = verdi
WAVEFLAGS += -l wave_dump.log \
             $(UVMLIBS) $(INCDIR) $(SRCS) \
             -top $(TOP) -sv -q -ssf $(WAVEFILE)

## build rules

$(SIMV): $(SRCS) $(DEP)
	@echo "----- vcs -----"
	@cd $(DST_DIR) && bash -c \
	"$(VCS) $(VFLAGS) $(SRCS) -top $(TOP)"

$(WAVEFILE): $(SIMV)

## deault goal
.DEFAULT_GOAL = simv

## build order control
simv: $(SIMV)
run: simv
	@$(SIMV) $(RUNOPTS)
wave: $(WAVEFILE)
	@cd $(DST_DIR) && $(WAVETOOL) $(WAVEFLAGS)

## generate uvm-1.1d tags
tags:
	@ctags -R --fields=+nKz -f $@ -R ./uvm-1.1d/src

clean:
	rm -rf $(DST_DIR)

.PHONY: clean tags run wave simv
