set_global_assignment -entity "Clock_PLL" -library "lib_Clock_PLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "Clock_PLL" -library "lib_Clock_PLL" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "Clock_PLL" -library "lib_Clock_PLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_Clock_PLL" -name SPD_FILE [file join $::quartus(sip_path) "Clock_PLL.spd"]

set_global_assignment -library "lib_Clock_PLL" -name MISC_FILE [file join $::quartus(sip_path) "Clock_PLL_sim/Clock_PLL.vo"]
