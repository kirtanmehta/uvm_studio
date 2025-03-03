class base_sequence extends uvm_sequence#(mem_sequence_item);
    `uvm_object_utils(base_sequence)


    mem_sequence_item mem_txn;
    rand logic [7:0] addr[$];

    // constraint addr_wdata_c {mem_txn.addr == mem_txn.wdata; }

    constraint c1 {
            addr.size() inside {[2:4],7 ,8,9 };
            foreach (addr[i]) {              
                if (i >0) addr[i] < addr[i-1];}
    }

    function new (string name = "base_sequnce");
        super.new(name);
        mem_txn = mem_sequence_item::type_id::create("mem_txn");
    endfunction


    task body();
        super.body();
        
        $display("addr constraint value = %p ", this.addr);

        for (byte i = 0; i <5; i++) begin
            mem_txn.wr_en = 1;
            mem_txn.rd_en = 0;
            mem_txn.addr = i;
            mem_txn.wdata = i;
            this.start_item(mem_txn);
            // mem_txn.randomize();
            this.finish_item(mem_txn);
        end

        for (byte i = 0; i <5; i++) begin
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