TOP       = top_tb
DUTDIR    = $(addprefix $(CHDIR)/, dut)
INC_PATH += +$(SECTDIR)+$(DUT)
DEP       = $(shell find "$(SECTDIR)" "$(DUTDIR)" -name "*.sv")
SRCS     += $(addprefix $(SECTDIR)/, top_tb.sv)
SRCS     += $(addprefix $(DUTDIR)/, dut.sv)
