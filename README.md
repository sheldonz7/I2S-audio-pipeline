# comp3601-audio-project
## Run the following commands in order on the Xilinx Command Line Interface
- hsi open_hw_design design_1_wrapper.xsa
- hsi set_repo_path D:/system-device-tree-xlnx
    - The repo here is from https://github.com/Xilinx/system-device-tree-xlnx
- hsi create_sw_design device-tree -os device_tree -proc psu_cortexa53_0
- hsi set_property CONFIG.dt_overlay true [hsi::get_os]
- hsi generate_target -dir <dir_name>
- hsi close_hw_design design_1_wrapper

## Compile the .dtsi to .dtbo using DTC(device tree compiler)
dtc -@ -O dtb -o pl.dtbo pl.dtsi


## petalinux
- run the sdk.sh to install sdk
- source the environment variable, source <path-to-env>, default: /opt/petalinux/2021.1/environment-setup-cortexa72-cortexa53-xilinx-linux 


## configure FPGA PL
copy the .bin and .dtbo to ~/lib/firmware/xilinx
xmutil listapps
xmutil unloadapp
xmutil loadapp <app_name>

