# This file contains the necessary constraints to achieve FIR size and speed
# requirements.  It is machine generated and should not be modified.

proc add_fir_constraints {args} {

	package require ::quartus::project
	package require ::quartus::flow


	# Compiler Assignments remove
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "tdl_da_lc"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "lc_tdl_strat"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "lc_tdl_strat_cen"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "sadd_lpm"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "tsadd_lpm"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "sadd_lpm_cen"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "tsadd_lpm_cen"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "sadd_cen"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "tsadd_cen"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "lc_tdl_mr"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "lc_tdl_en"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "sadd_reg_top"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "sadd_lpm_cen"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "tsadd_reg_top_cen"
	set_global_assignment -name "DSP_BLOCK_BALANCING" -remove -entity "low_pass_filter1_st"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "mlu_nd_lc"
	################################################################################################ 
	# uncomment the following lines if you want to disable shift register recognition              # 
	################################################################################################ 
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "msft_data"
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "msft_data" "OFF" 
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "msft_data_reseq"
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "msft_data_reseq" "OFF" 
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "msft_data_reseq_mc"
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "msft_data_reseq_mc" "OFF" 
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -remove -entity "msft_reseq_mc"
	#set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "msft_reseq_mc" "OFF" 
	################################################################################################ 
	
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tdl_da_lc" "OFF" 
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd_lpm" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tsadd_lpm" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd_lpm_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tsadd_lpm_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd" "OFF" 
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tsadd" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "lc_tdl_strat" "OFF" 
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "lc_tdl_mr" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "lc_tdl_en" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "lc_tdl_strat_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd_reg_top_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tsadd_reg_top_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd_reg_top" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tsadd_reg_top" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "tsadd_lpm_reg_top_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "sadd_lpm_reg_top_cen" "OFF"
	set_global_assignment -name "AUTO_SHIFT_REGISTER_RECOGNITION" -entity "mlu_nd_lc" "OFF"
	set_global_assignment -name "DSP_BLOCK_BALANCING" -entity "low_pass_filter1_st" "LOGIC ELEMENTS"
}
add_fir_constraints
