class base_sequence extends uvm_sequence#(mem_sequence_item);
    `uvm_object_utils(base_sequence)


    mem_sequence_item mem_txn;


    // constraint addr_wdata_c {mem_txn.addr == mem_txn.wdata; }

    function new (string name = "base_sequnce");
        super.new(name);
        mem_txn = mem_sequence_item::type_id::create("mem_txn");
    endfunction


    task body();
        super.body();
        
        for (int i = 0; i <5; i++) begin
            mem_txn.wr_en = 1;
            mem_txn.rd_en = 0;
            mem_txn.addr = i;
            mem_txn.wdata = i;
            this.start_item(mem_txn);
            // mem_txn.randomize();
            this.finish_item(mem_txn);
        end

        for (int i = 0; i <5; i++) begin
            mem_txn.wr_en = 0;
            mem_txn.rd_en = 1;
            mem_txn.addr = i;
            // mem_txn.wdata = i;
            this.start_item(mem_txn);
            // mem_txn.randomize();
            this.finish_item(mem_txn);
        end


    endtask


endclass