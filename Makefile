# Makefile for UVM PRACTICE

export UVMSZ_HOME = /home/kodeyang/ic_proj/uvm/uvm_practice

CHAPTER = ch2
SECTION = section2.5/2.5.2
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

## some workdir and simv file
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
VFLAGS    += -sverilog -l vcs.log -q -j8 \
		 			   $(UVMLIBS) $(TIMESCALE) $(INCDIR)

## runtime flags and defines
TESTNAME   = my_case1
VERBOSE    = UVM_MEDIUM
#RUNARGS   += +UVM_CONFIG_DB_TRACE
RUNARGS   += $(addprefix +UVM_TESTNAME=, $(TESTNAME))
RUNARGS   += $(addprefix +UVM_VERBOSITY=, $(VERBOSE))
RUNARGS   += -k $(DST_DIR)/ucli.key -l $(DST_DIR)/outv.log

## wave flags and options(verdi)
WAVEFILE   = $(DST_DIR)/a.fsdb
WAVETOOL   = verdi
WAVEFLAGS += -l wave_dump.log \
						 $(UVMLIBS) $(INCDIR) $(SRCS) \
						 -top $(TOP) -sv -q -ssf $(WAVEFILE)

## build rules
$(SIMV): $(SRCS) $(DEP)
	@$(MAKE) -s -C $(WORKDIR) comp

$(WAVEFILE): $(SIMV)
	@$(MAKE) -s -C $(WORKDIR) run

## miscellaneous
comp:
	@echo "----- vcs -----"
	@cd $(DST_DIR) && bash $(VCS) $(VFLAGS) $(SRCS) -top $(TOP)

run: $(SIMV)
	@$(SIMV) $(RUNARGS)

wave: $(WAVEFILE)
	@cd $(DST_DIR) && $(WAVETOOL) $(WAVEFLAGS)

clean:
	rm -rf $(DST_DIR)

.PHONY: clean run wave comp
