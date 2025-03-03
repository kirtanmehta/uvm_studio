class mem_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(mem_sequence_item)

    function new (string name = "mem_sequence_item");
        super.new(name);
    endfunction


    randc bit [7:0] addr;
    randc bit wr_en;
    randc bit rd_en;
    randc bit [7:0] wdata;

    logic [7:0] rdata;

    
    constraint wr_rd_en_c {wr_en != rd_en;}


endclass
