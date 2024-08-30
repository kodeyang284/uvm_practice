TOP       = top_tb
DUTDIR    = $(addprefix $(UVMSZ_HOME)/src/ch2/, dut)
INC_PATH += +$(SECTDIR)
DEP       = $(shell find "$(SECTDIR)" "$(DUTDIR)" -name "*.sv")
SRCS     += $(addprefix $(SECTDIR)/, top_tb.sv)
SRCS     += $(addprefix $(DUTDIR)/, dut.sv)
