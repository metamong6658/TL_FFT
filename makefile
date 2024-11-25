.DEFAULT_GOAL := mode1
vcs_option = -kdb -sverilog -full64 -debug_access -R -timescale=1ns/1ps

mode1:
	@mkdir -p $(PWD)/MODE1/LOG
	@mkdir -p $(PWD)/MODE1/FILE
	@rm -rf $(PWD)/MODE1/LOG/*
	@rm -rf $(PWD)/MODE1/FILE/*
	@cd $(PWD)/MODE1; (python3 py_data.py)
	@cd $(PWD)/MODE1/LOG; (vcs $(vcs_option) -f ../design.vcs) | tee ./vcs_compile.log
	@cd $(PWD)/MODE1/LOG; (verdi -dbdir ./simv.daidir)
	@cd $(PWD)/MODE1; (python3 py_sqnr.py)

mode2:
	@mkdir -p $(PWD)/MODE2/LOG
	@mkdir -p $(PWD)/MODE2/FILE
	@rm -rf $(PWD)/MODE2/LOG/*
	@rm -rf $(PWD)/MODE2/FILE/*
	@cd $(PWD)/MODE2; (python3 py_data.py)
	@cd $(PWD)/MODE2/LOG; (vcs $(vcs_option) -f ../design.vcs) | tee ./vcs_compile.log
	@cd $(PWD)/MODE2/LOG; (verdi -dbdir ./simv.daidir)
	@cd $(PWD)/MODE2; (python3 py_sqnr.py)

mode3:
	@mkdir -p $(PWD)/MODE3/LOG
	@mkdir -p $(PWD)/MODE3/FILE
	@rm -rf $(PWD)/MODE3/LOG/*
	@rm -rf $(PWD)/MODE3/FILE/*
	@cd $(PWD)/MODE3; (python3 py_data.py)
	@cd $(PWD)/MODE3/LOG; (vcs $(vcs_option) -f ../design.vcs) | tee ./vcs_compile.log
	@cd $(PWD)/MODE3/LOG; (verdi -dbdir ./simv.daidir)
	@cd $(PWD)/MODE3; (python3 py_sqnr.py)

mode4:
	@mkdir -p $(PWD)/MODE4/LOG
	@mkdir -p $(PWD)/MODE4/FILE
	@rm -rf $(PWD)/MODE4/LOG/*
	@rm -rf $(PWD)/MODE4/FILE/*
	@cd $(PWD)/MODE4; (python3 py_data.py)
	@cd $(PWD)/MODE4/LOG; (vcs $(vcs_option) -f ../design.vcs) | tee ./vcs_compile.log
	@cd $(PWD)/MODE4/LOG; (verdi -dbdir ./simv.daidir)
	@cd $(PWD)/MODE4; (python3 py_sqnr.py)
