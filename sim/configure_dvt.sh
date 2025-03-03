#!/bin/bash

CWD=/proj/enigma/users/kirtan/studio/sim
DVT_DEFAULT_BUILD_PATH=/proj/enigma/users/kirtan/studio/.dvt/default.build

mkdir -p /proj/enigma/users/kirtan/studio/.dvt
touch $DVT_DEFAULT_BUILD_PATH

echo +dvt_prepend_init +dvt_env+UVM_HOME=/cad/mgc/questa/2023.3_1/questasim/verilog_src/uvm-1.1d > $DVT_DEFAULT_BUILD_PATH

# echo +dvt_prepend_init > $DVT_DEFAULT_BUILD_PATH

# echo +dvt_init+questa.vlog -uvm +incdir+/site/cad/mgc/questaVIP/2024.2_20240720/questa_mvc_src/sv/ddrx /site/cad/mgc/questaVIP/2024.2_20240720/questa_mvc_src/sv/ddrx/mgc_ddr_pkg.sv >> $DVT_DEFAULT_BUILD_PATH
echo +dvt_init+questa.vlog /cad/mgc/questa/2023.3_1/questasim/verilog_src/dpi_cpack/dpi_cpackages.sv >> $DVT_DEFAULT_BUILD_PATH

# make -f $CWD/Makefile cli TEST_NAME=test_top -n | \grep "^vlog" | sed -e "s/^vlog/+dvt_init+questa.vlog -uvm/" >> $DVT_DEFAULT_BUILD_PATH
