`ifndef AXI4_MASTER_NBK_SLAVE_MEM_MODE_READ_INCR_BURST_SEQ_INCLUDED_
`define AXI4_MASTER_NBK_SLAVE_MEM_MODE_READ_INCR_BURST_SEQ_INCLUDED_ 
//--------------------------------------------------------------------------------------------
// Class: axi4_master_nbk_slave_mem_mode_read_incr_burst_seq
// Extends the axi4_master_nbk_base_seq and randomises the req item
//--------------------------------------------------------------------------------------------
class axi4_master_nbk_slave_mem_mode_read_incr_burst_seq extends axi4_master_nbk_base_seq;
  `uvm_object_utils(axi4_master_nbk_slave_mem_mode_read_incr_burst_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_nbk_slave_mem_mode_read_incr_burst_seq");
  extern task body();
endclass : axi4_master_nbk_slave_mem_mode_read_incr_burst_seq

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_master_nbk_slave_mem_mode_read_incr_burst_seq
//--------------------------------------------------------------------------------------------
function axi4_master_nbk_slave_mem_mode_read_incr_burst_seq::new(string name = "axi4_master_nbk_slave_mem_mode_read_incr_burst_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master_nbk transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi4_master_nbk_slave_mem_mode_read_incr_burst_seq::body();
  super.body();
  
  start_item(req);
  if(!req.randomize() with {
                            req.tx_type == READ;
                            req.arburst == READ_INCR;
                            req.transfer_type == NON_BLOCKING_READ;}) begin

    `uvm_fatal("axi4","Rand failed");
  end
  `uvm_info("DDD",$sformatf("req:%0s/n",req.sprint()),UVM_NONE);
  finish_item(req);

endtask : body

`endif

