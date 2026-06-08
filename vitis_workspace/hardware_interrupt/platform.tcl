# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/hardware_interrupt/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace/hardware_interrupt/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {hardware_interrupt}\
-hw {/home/gio/uni/aca/fpga/aca_fpga_homework2.1/hardware_interrupt.xsa}\
-out {/home/gio/uni/aca/fpga/aca_fpga_homework2.1/vitis_workspace}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {hardware_interrupt}
domain active {zynq_fsbl}
domain active {standalone_microblaze_0}
platform generate -quick
platform generate
