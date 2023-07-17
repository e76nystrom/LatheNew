set_global_assignment -entity "SystemClk" -library "lib_SystemClk" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "SystemClk" -library "lib_SystemClk" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "SystemClk" -library "lib_SystemClk" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_SystemClk" -name SPD_FILE [file join $::quartus(sip_path) "../SystemClk.spd"]
set_global_assignment -library "lib_SystemClk" -name MISC_FILE [file join $::quartus(sip_path) "../../SystemClk.qsys"]

set_global_assignment -library "lib_SystemClk" -name MISC_FILE [file join $::quartus(sip_path) "SystemClk.vhd"]
set_global_assignment -library "lib_SystemClk" -name MISC_FILE [file join $::quartus(sip_path) "submodules/SystemClk_altclkctrl_0.vhd"]
