package uvm_package_files;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"


    `include "./sequences/mem_sequence_item.sv"  
    
    `include "./uvc/mem_sequencer.sv"
    `include "./uvc/mem_driver.sv"  
    `include "./uvc/mem_monitor.sv"  
    `include "./uvc/mem_agent.sv"  
    `include "./uvc/mem_env.sv"  

    `include "./sequences/base_sequence.sv"

    `include "./tests/base_test.sv" 

endpackage