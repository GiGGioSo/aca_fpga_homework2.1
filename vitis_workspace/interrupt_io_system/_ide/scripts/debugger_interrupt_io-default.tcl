# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/interrupt_io_system/_ide/scripts/debugger_interrupt_io-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/interrupt_io_system/_ide/scripts/debugger_interrupt_io-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo Z7 210351BA1DB5A" && level==0 && jtag_device_ctx=="jsn-Zybo Z7-210351BA1DB5A-23727093-0"}
fpga -file /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/interrupt_io/_ide/bitstream/hardware_interrupt.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/hardware_interrupt/export/hardware_interrupt/hw/hardware_interrupt.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/interrupt_io/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/interrupt_io/Debug/interrupt_io.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
