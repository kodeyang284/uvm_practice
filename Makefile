export UVMSZ_HOME = $(HOME)/Public/uvm_practice

CHAPTER := ch6
#SECTION := section6.5/6.5.3/uvm_do_on
SECTION := prac6.5
CHDIR   := $(addprefix $(UVMSZ_HOME)/src/, $(CHAPTER))
SECTDIR := $(addprefix $(CHDIR)/, $(SECTION))
include $(CHDIR)/$(CHAPTER).mk

ifeq ($(flavor TOP), undefined)
  $(error Need a top module)
endif

ifeq ($(flavor SRCS), undefined)
  $(error Nothing to build)
endif

ifeq ($(flavor INC_PATH), undefined)
  $(error Need include path)
endif

WORKDIR    = $(shell pwd)
DST_DIR    = $(WORKDIR)/build
SIMV       = $(DST_DIR)/simv
$(shell mkdir -p $(DST_DIR))

UVM_HOME   = $(UVMSZ_HOME)/uvm-1.1d
UVMLIBS    = +incdir+$(UVM_HOME)/src \
				     $(UVM_HOME)/src/uvm_pkg.sv \
				     $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS

TIMESCALE  = -timescale=1ns/1ps
VCS        = vcs
INCDIR    += $(addprefix +incdir, $(INC_PATH))
DEFINES   += +UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
#VFLAGS    +=-debug_acc+all -debug_region+cell+encrypt
VFLAGS    += $(addprefix +define, $(DEFINES))
VFLAGS    += -sverilog -l vcs.log -q \
             $(UVMLIBS) $(TIMESCALE) $(INCDIR)

TESTNAME   = my_case0
VERBOSE    = UVM_MEDIUM
#RUNOPTS   += $(addprefix +UVM_VERBOSITY=, $(VERBOSE))
#RUNOPTS   += +UVM_CONFIG_DB_TRACE
#RUNOPTS   += +UVM_PHASE_TRACE
#RUNOPTS   += +UVM_NO_RELNOTES
RUNOPTS   += $(addprefix +UVM_TESTNAME=, $(TESTNAME))
RUNOPTS   += -k $(DST_DIR)/ucli.key -l $(DST_DIR)/simv.log

WAVEFILE   = $(DST_DIR)/a.fsdb
WAVETOOL   = verdi
WAVEFLAGS += -l wave_dump.log \
             $(UVMLIBS) $(INCDIR) $(SRCS) \
             -top $(TOP) -sv -q -ssf $(WAVEFILE)

$(SIMV): $(SRCS) $(DEP)
	@echo "----- vcs -----"
	@cd $(DST_DIR) && bash -c \
	"$(VCS) $(VFLAGS) $(SRCS) -o $(basename $@) -top $(TOP)"

$(WAVEFILE): $(SIMV)

.DEFAULT_GOAL = simv

simv: $(SIMV)
run: simv
	@$(SIMV) $(RUNOPTS)
wave: $(WAVEFILE)
	@cd $(DST_DIR) && $(WAVETOOL) $(WAVEFLAGS)

tags:
	@ctags -R --fields=+nKz -f $@ -R ./uvm-1.1d/src

log:
	@grep UVM_INFO build/simv.log | \
	sed 's%$(SECTDIR)/%%; s/UVM_INFO\s//' | grep '^my' | \
	sed 's/uvm_test_top/top/g'

help:
	@less ./scripts/vcs.1

clean:
	rm -rf $(DST_DIR)

.PHONY: clean tags run wave simv log help
