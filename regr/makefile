
#eman server shutdown_db, eman server run_db
#eman server shutdown_web, eman server run_web, eman server check_web
# export EMAN_PROJECT=apb_adder
PROJECT_NAME=

regr_cfg = -top_run_dir rundir -local_host -merge_dir mergedCovDir  -auto_clean 

init:
	eman project create ${PROJECT_NAME}

env:
	export EMAN_PROJECT=${PROJECT_NAME}

regr:
	eman -regr_config ../regr_cfg/basic.emc ${regr_cfg}

#-plan ../plan/alu_plan.hvp

#mkdir temp simv.vdb/snps/coverage/db/testdata
cov_trans:
	rm -rf temp simv.vdb/snps/coverage/db/testdata/*
	@if [! -d temp]; then \
		mkdir temp; \
	fi
	@if [! -d simv.vdb/snps/coverage/db/testdata]; then \
		mkdir simv.vdb/snps/coverage/db/testdata; \
	fi
	cp -rf case_*_test/*_test_* temp
	cp -rf temp/case*_test_*/elab_v1/*.vdb/snps/coverage/db/testdata/* simv.vdb/snps/coverage/db/testdata
	urg -full64 -dir simv -format both

cov:
	verdi -cov -covdir mergedCovDir/merged/merged.vdb &

include ../sim/makefile

User_Define +=+define+REGR_SIM