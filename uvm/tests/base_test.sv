class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    mem_env env;
    base_sequence base_seq;

    function new(string name = "base_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    //---------------------------------------
    // build_phase - create the components
    //---------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = mem_env::type_id::create("env", this);
        base_seq = base_sequence::type_id::create("base_seq", this);
        
    endfunction : build_phase
    

    //---------------------------------------
    // end_of_elobaration phase
    //---------------------------------------  
    virtual function void end_of_elaboration();
        //print's the topology
        print();
    endfunction

    
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    base_seq.randomize();
    base_seq.start(env.mem_agnt.sequencer );

    phase.drop_objection(this);
  endtask

 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 

endclass



