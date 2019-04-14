################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
main.obj: ../main.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: MSP430 Compiler'
	"D:/ccs/CCS5.4.0.00091_win32/ccs5.4/ccsv5/tools/compiler/msp430_4.1.5/bin/cl430" -vmsp --abi=eabi -O0 --opt_for_speed=0 -g --include_path="D:/ccs/CCS5.4.0.00091_win32/ccs5.4/ccsv5/ccs_base/msp430/include" --include_path="D:/ccsProgramFile/JLX12864_Driver/src" --include_path="D:/ccs/CCS5.4.0.00091_win32/ccs5.4/ccsv5/tools/compiler/msp430_4.1.5/include" --advice:power=all --define=__MSP430G2553__ --diag_warning=225 --display_error_number --diag_wrap=off --printf_support=minimal --preproc_with_compile --preproc_dependency="main.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


