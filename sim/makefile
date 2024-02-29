VCS_VERDI1 = ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab
VCS_VERDI2 = ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a
VCSDEF =  -cpp g++ -cc gcc -LDFLAGS -no-pie -LDFLAGS -Wl,--no-as-needed -CFLAGS -fPIE
#===========================================================
## Must Set
TESTNAME 	= apbm_func_test
UVM_VERB 	= UVM_HIGH #{}
TIMESCALE = 1ns/1ps 
## Optional
User_Define = 
User_ELAB =
User_SIM = 


COV_EN		= 0 #save cov data
SVA_EN		= 0 #enable sva
SIM_INFO	= 0 #print sim info
AMS_EN		= 1 #ams sim
XPROP_EN	= 0 #x propagation
FGP_EN		= 0 #fast gate propagation
CORE 			= 3
DPO_L_EN	= 0
DPO_A_EN	= 0

#POST SIM
POST_EN	= 0
POST_OPT_FILE =../sim_cfg/async.list
SDF_INSTANCE	=tb_top.dut
SDF_FILE_PATH	=
SDF_MODE			=

#===========================================================
projectpath=$(pwd)
SEED = `date "+%m%d%H%M%S"`
USER_ELAB = 
USER_SIM  =

ifeq ($(strip $(AMS_EN)),1)
USER_ELAB += -ad=../sim_cfg/cosim_xa.init
User_Define += +define+ASM_SIM
else ifeq ($(strip $(AMS_EN)),2)
USER_ELAB += -ad=../sim_cfg/cosim_finesim.init
User_Define += +define+ASM_SIM
else ifeq ($(strip $(AMS_EN)),3)
USER_ELAB += -ad=../sim_cfg/co_sim_xa_veriloga.init
User_Define += +define+ASM_SIM
endif

ifeq ($(strip $(XPROP_EN)),1)
USER_ELAB += -xprop=../sim_cfg/xprop.cfg
endif

ifeq ($(strip $(FGP_EN)),1)
USER_ELAB += fgp
USER_SIM += -fgp=-fgp=num_threads:$(CORE),diag:ruse,dynamictoggle
endif

ifeq ($(strip $(DPO_L_EN)),1)
USER_ELAB += -dpo -dpo_opts mode=learn+apps=default,lint,upfopt,pgates -dpo_opts design_tag=design_dpo+dbdir=dpo_learn_db
USER_SIM += -dpo_opts test_type=uvm
endif

ifeq ($(strip $(DPO_A_EN)),1)
USER_ELAB += -dpo -dpo_opts mode=apply+apps=default,fgp,lint,upfopt,pgates -dpo_opts design_tag=design_dpo+learn_dbdir=dpo_learn_db+reco_file=dpo_reco.csv
USER_SIM += -dpo_opts test_type=uvm
endif

ifeq ($(strip $(COV_EN)),1)
COV_ELAB =	-cm line+cond+tgl+fsm+branch+assert \
	-cm_hier ../sim_cfg/cm.cfg -cm_assert_hier ../sim_cfg/cm_ass.cfg \
	-assert enable_diag+vpiSeqBegin+vpiSeqFail
COV_SIM = -cm line+cond+tgl+fsm+branch+assert -cm_name ${TESTNAME} \
	-assert enable_diag+vpiSeqBegin+vpiSeqFail
else ifeq ($(strip $(SVA_EN)),1)
COV_ELAB =	-cm assert -cm_hier ../sim_cfg/cm.cfg \
	-cm_assert_hier ../sim_cfg/cm_ass.cfg \
	-assert enable_diag+vpiSeqBegin+vpiSeqFail+finish_maxfail=20
COV_SIM = -cm assert -cm_name ${TESTNAME} \
	-assert +finish_maxfail=20+report=assert.log +fsdb+sva_success
else
COV_ELAB = 
COV_SIM = 
endif

ifeq ($(strip $(SIM_INFO)),1)
USER_ELAB += -simprofile
USER_SIM += -simprofile[time|mem]
endif

ifeq ($(strip $(SDF_MODE)),wc)
SDF_FILE = -sdf max:${SDF_INSTANCE}:${SDF_FILE_PATH}/xxx.sdf
else ifeq ($(SDF_MODE),tt)
SDF_FILE = -sdf typ:${SDF_INSTANCE}:${SDF_FILE_PATH}/xxx.sdf
else ifeq ($(SDF_MODE),bc)
SDF_FILE = -sdf min:${SDF_INSTANCE}:${SDF_FILE_PATH}/xxx.sdf
endif

ifeq ($(strip $(POST_EN)),1) #post with sdf
POST_ELAB =	+neg_tchk -negdelay +sdfverbose \
	+optconfigfile+${POST_OPT_FILE} ${SDF_FILE}
FILE_LIST	= -f ../sim_cfg/filelist_verif -f ../sim_cfg/filelist_lib \
	${SDF_FILE_PATH}/Gate.v
SINGLE_COMP =
else ifeq ($(strip $(POST_EN)),2) #netlist
POST_ELAB = +nospecify +notimingcheck
FILE_LIST	= -f ../sim_cfg/filelist_verif -f ../sim_cfg/filelist_lib \
	${SDF_FILE_PATH}/Gate.v +nospecify
SINGLE_COMP =
else #pre sim
POST_ELAB = +nospecify +notimingcheck
FILE_LIST	= -f ../sim_cfg/filelist +nospecify
SINGLE_COMP =
endif

ifeq ($(strip $(AMS_EN)),3)
FILE_LIST	= -f ../sim_cfg/filelist_va +nospecify
endif 


all: clean precomp elab sim
restart:  precomp elab
recomp: precomp elab
resim: precomp elab sim

#step 1 : compile
VCOMP= vlogan -full64 -override_timescale=${TIMESCALE} \
	 -kdb -lca +v2k -sverilog ${User_Define} 


precomp:
	cp ../sim_cfg/cosim_finesim.cfg ./finesim.cfg
	${SINGLE_COMP} -l vlogan_single.log
	$(VCOMP) ${FILE_LIST} -l vlogan.log
#+nospecify +notimingcheck +libext+.v -l vlogan.log

#step 2 : elaborates
elab:
	vcs -full64 -kdb -lca -Mupdate +notice \
	-override_timescale=${TIMESCALE} \
	+lint=TFIPC-L +lint=PCWM  \
	-debug_access+all -top tb_top -o simv \
	${COV_ELAB} ${POST_ELAB} ${USER_ELAB} \
	-LDFLAGS -rdynamic -P ${VCS_VERDI1} ${VCS_VERDI2} -l comp.log

#-Mdir  		#incremental comp output dir
#-Mlib			#incremental comp input dir
#-Mupdate   #up makefile between comps
#-fgp -partcomp -fastpartcomp=j1
#-LDFLAGS -lrt ${SVLIB_HOME}/src/dpi/svlib_dpi.c

#step 3 : simulate
sim:
	./simv +ntb_random_seed=$(SEED) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=${UVM_VERB} \
	${COV_SIM} ${USER_SIM} ${User_Define} \
	uvm_Debug -l sim.log

#-fgp=num_threads:3,diag:ruse,dynamictoggle
#+UVM_VERDI_TRACE="UVM_AWARE+RAL+TLM+TLM2+IMP+HIER+COMPWAVE" +UVM_TR_RECORD
#+vcs+loopreport +vcs+loopdetect +vcs+looplimit=10000
#+fsdb+region +fsdb+delta
#+fsdb+gate=off
#+fsdb+functions

simg:
	./simv -verdi +ntb_random_seed=$(SEED) +UVM_TESTNAME=$(TESTNAME)\
	-l sim.log uvm_Debug \
	${COV_SIM} ${USER_SIM} ${User_Define} \
	+UVM_VERDI_TRACE="UVM_AWARE+RAL+TLM+TLM2+IMP+HIER+COMPWAVE" +UVM_TR_RECORD

dvecov:
	dve -covdir simv.vdb &

verdicov:
	verdi -cov -covdir simv.vdb &

urg:
	urg -full64 -dir ./simv.vdb -format both
	firefox urgReport/dashboard.html

urghvp:
	urg -full64 -dir ./simv.vdb -format both -plan ../tb/plan.hvp
	firefox urgReport/dashboard.html

#step 4 : view
verdi:
	verdi -nologo +v2k -sverilog  \
	-elab ./simv.daidir/kdb.elab++ \
	-ssf tb_top.fsdb & 
	
verdi_hwsw:
	verdi -nologo +v2k -sverilog  \
	-elab ./simv.daidir/kdb.elab++ \
	-ssf tb_hwsw.fsdb & 

#DPO
dpo_merge:
	dporg merge -d dpo_learn_db

dpo_dump:dpo_merge
	dporg dump -d dpo_learn_db

dpo_report:
	dporg report -d dpo_learn_db

dpo_view:
	firefox ./dpo_learn_db/dpo_home.html

#DUTRCA
drca_gen:
	autorca -gen_cfg_template rca_cfg.yaml -gen_mode dutrca

drca_run:
	autorca -cfg rca_cfg.yaml

drca_view:
	autorca -load_trace_report tracediff_report.xml

#XRCA
xrca_auto:
	xrca -ssf tb_top.fsdb -lca

xrca_user:
	xrca -ssf tb_top.fsdb -lca \
	-dbdir simv.daidir \
	-signal_list ./signal_list.txt

xrca_user_root:
	xrca -ssf tb_top.fsdb -lca \
	-dbdir simv.daidir \
	-signal_list ./signal_list.txt \
	-cause_count 0

xrca_verdi:
	verdi -load_trace_report tracediff_report.xml -apex

clean:
	@echo "Cleaning up ..."
	@rm -rf csrc DVEfiles simv simv.daidir ucli.key VCS*
	@rm -rf *.log *.vpd *.ddc *.svf *SDF *Synth *Netlist* *.fsdb
	@rm -rf alib-52 64 work.lib++ vhdlanLog urgReport
	@rm -rf AN.DB novas.* simv.cst  vc_hdrs.h

cleanall:clean
	@echo "Cleaning up ..."
	@rm -rf simv.vdb verdi* .fsm.sch.verilog.xml simv.msv