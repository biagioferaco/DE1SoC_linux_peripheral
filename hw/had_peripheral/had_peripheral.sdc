#**************************************************************
# Altera DE1-SoC SDC settings
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]
#create_clock -period 20 [get_ports CLOCK2_50]
#create_clock -period 20 [get_ports CLOCK3_50]
#create_clock -period 20 [get_ports CLOCK4_50]


#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)
set_input_delay -max -clock clk_dram -0.048 [get_ports DRAM_DQ*]
set_input_delay -min -clock clk_dram -0.057 [get_ports DRAM_DQ*]


#**************************************************************
# Set Output Delay
#**************************************************************
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
set_output_delay -max -clock clk_dram 1.452  [get_ports DRAM_DQ*]
set_output_delay -min -clock clk_dram -0.857 [get_ports DRAM_DQ*]
set_output_delay -max -clock clk_dram 1.531 [get_ports DRAM_ADDR*]
set_output_delay -min -clock clk_dram -0.805 [get_ports DRAM_ADDR*]
set_output_delay -max -clock clk_dram 1.533  [get_ports DRAM_*DQM]
set_output_delay -min -clock clk_dram -0.805 [get_ports DRAM_*DQM]
set_output_delay -max -clock clk_dram 1.510  [get_ports DRAM_BA*]
set_output_delay -min -clock clk_dram -0.800 [get_ports DRAM_BA*]
set_output_delay -max -clock clk_dram 1.520  [get_ports DRAM_RAS_N]
set_output_delay -min -clock clk_dram -0.780 [get_ports DRAM_RAS_N]
set_output_delay -max -clock clk_dram 1.5000  [get_ports DRAM_CAS_N]
set_output_delay -min -clock clk_dram -0.800 [get_ports DRAM_CAS_N]
set_output_delay -max -clock clk_dram 1.545 [get_ports DRAM_WE_N]
set_output_delay -min -clock clk_dram -0.755 [get_ports DRAM_WE_N]
set_output_delay -max -clock clk_dram 1.496  [get_ports DRAM_CKE]
set_output_delay -min -clock clk_dram -0.804 [get_ports DRAM_CKE]
set_output_delay -max -clock clk_dram 1.508  [get_ports DRAM_CS_N]
set_output_delay -min -clock clk_dram -0.792 [get_ports DRAM_CS_N]




#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_clocks u0|pll_0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk] -to [get_clocks u0|pll_0|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk]
set_false_path -from [get_clocks u0|pll_0|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk] -to [get_clocks u0|pll_0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************

