`ifndef AXI4_SLAVE_DRIVER_BFM_INCLUDED_
`define AXI4_SLAVE_DRIVER_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : axi4_slave_driver_bfm
//Used as the HDL driver for axi4
//It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import axi4_globals_pkg::*;
interface axi4_slave_driver_bfm(input                     aclk    , 
                                input                     aresetn ,
                                //Write_address_channel
                                input [3:0]               awid    ,
                                input [ADDRESS_WIDTH-1:0] awaddr  ,
                                input [3: 0]              awlen   ,
                                input [2: 0]              awsize  ,
                                input [1: 0]              awburst ,
                                input [1: 0]              awlock  ,
                                input [3: 0]              awcache ,
                                input [2: 0]              awprot  ,
                                input                     awvalid ,
                                output reg	              awready ,

                                //Write_data_channel
                                input [DATA_WIDTH-1: 0]     wdata  ,
                                input [(DATA_WIDTH/8)-1: 0] wstrb  ,
                                input                       wlast  ,
                                input [3: 0]                wuser  ,
                                input                       wvalid ,
                                output reg	                wready ,

                                //Write Response Channel
                                output reg [3:0]            bid    ,
                                output reg [1:0]            bresp  ,
                                output reg [3:0]            buser  ,
                                output reg                  bvalid ,
                                input		                    bready ,

                                //Read Address Channel
                                input [3: 0]                arid    ,
                                input [ADDRESS_WIDTH-1: 0]  araddr  ,
                                input [7:0]                 arlen   ,
                                input [2:0]                 arsize  ,
                                input [1:0]                 arburst ,
                                input [1:0]                 arlock  ,
                                input [3:0]                 arcache ,
                                input [2:0]                 arprot  ,
                                input [3:0]                 arQOS   ,
                                input [3:0]                 arregion,
                                input [3:0]                 aruser  ,
                                input                       arvalid ,
                                output reg                  arready ,

                                //Read Data Channel
                                output reg [3:0]                rid    ,
                                output reg [DATA_WIDTH-1: 0]    rdata  ,
                                output reg [(DATA_WIDTH/8)-1: 0]rstrb  ,
                                output reg [1:0]                rresp  ,
                                output reg                      rlast  ,
                                output reg [3:0]                ruser  ,
                                output reg                      rvalid ,
                                input		                        rready  
                              ); 
                              
  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 

  //-------------------------------------------------------
  // Importing axi4 slave driver proxy
  //-------------------------------------------------------
  import axi4_slave_pkg::axi4_slave_driver_proxy;

  //Variable : axi4_slave_driver_proxy_h
  //Creating the handle for proxy driver
  axi4_slave_driver_proxy axi4_slave_drv_proxy_h;
  
  reg [3:0] i = 0;
  reg [3: 0] bid_local; 
  //reg [3:0] a1 = 0;
  //integer wrap = 0,start_bound = 0,end_bound = 0,l_t1 = 0,l_t2 = 0;

  initial begin
    `uvm_info("axi4 slave driver bfm",$sformatf("AXI4 SLAVE DRIVER BFM"),UVM_LOW);
  end

  string name = "AXI4_SLAVE_DRIVER_BFM";

  // Creating Memories for each signal to store each transaction attributes

  reg [	15: 0]	            mem_awid	  [0:19];
  reg [	ADDRESS_WIDTH-1: 0]	mem_waddr	  [20];
  reg [	7:0]	              mem_wlen	  [256] ;
  reg [	2:0]	              mem_wsize	  [20];
  reg [ 1	: 0]	            mem_wburst  [20];
  reg [ 1	: 0]	            mem_wlock	  [20];
  reg [ 3	: 0]	            mem_wcache  [20];
  reg [ 2	: 0]	            mem_wprot	  [20];
  reg [ 3	: 0]	            mem_wQOS  	[20];
  reg [ 3	: 0]	            mem_wregion	[20];
  reg [ 3	: 0]	            mem_wuser	  [20];

  reg [	15: 0]	            mem_rid		  [20];
  reg [	ADDRESS_WIDTH-1: 0]	mem_raddr	  [20];
  reg [	7	: 0]	            mem_rlen	  [256];
  reg [	2	: 0]	            mem_rsize	  [20];
  reg [ 1	: 0]	            mem_rburst  [20];
  reg [ 1	: 0]	            mem_rlock	  [20];
  reg [ 3	: 0]	            mem_rcache  [20];
  reg [ 2	: 0]	            mem_rprot	  [20];
  reg [ 3	: 0]	            mem_rQOS   	[20];
  reg [ 3	: 0]	            mem_rregion [20];
  reg [ 3	: 0]	            mem_ruser	  [20];

  //-------------------------------------------------------
  // Task: wait_for_system_reset
  // Waiting for the system reset to be active low
  //-------------------------------------------------------

  task wait_for_system_reset();
    @(negedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET ACTIVATED"),UVM_NONE)
    awready <= 0;
    wready  <= 0;
    bid     <= 'bx;
    bresp   <= 'bx;
    bvalid  <= 0;
  // arready <= 0;
    rid     <= 'bx;
    rdata   <= 'bx;
    rresp   <= 'bx;
    rvalid  <= 0;
    rlast   <= 0;
    @(posedge aresetn);
    `uvm_info(name,$sformatf("SYSTEM RESET DE-ACTIVATED"),UVM_NONE)
  endtask 
  
  //-------------------------------------------------------
  // Task: axi_write_address_phase
  // Sampling the signals that are associated with write_address_channel
  //-------------------------------------------------------

  task axi4_write_address_phase(axi4_write_transfer_char_s data_write_packet);
    @(posedge aclk);

    // Ready can be HIGH even before we start to check 
    // based on wait_cycles variable
    //

    // Can make awready to zero 
    awready <= 0;

    while(awvalid === 0) begin
      @(posedge aclk);
    end

    `uvm_info("SLAVE_DRIVER", $sformatf("DEBUG_MSHA :: outside of awvalid"), UVM_NONE); 
     
    // Sample the values
    // DO you work 

     data_write_packet.awid = awid;
     data_write_packet.awaddr = awaddr;
     data_write_packet.awlen = awlen;
     data_write_packet.awsize = awsize;
     data_write_packet.awburst = awburst;
     data_write_packet.awlock = awlock;
     data_write_packet.awcache = awcache;
     data_write_packet.awprot = awprot;
    // based on the wait_cycles we can choose to drive the awready

   `uvm_info(name,$sformatf("Before DRIVING WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
      awready<=0;
    end
    awready <= 1;


   // MSHA: // @(posedge aclk)begin
   // MSHA:    `uvm_info(name,"INSIDE WRITE_ADDRESS_PHASE",UVM_LOW)
   // MSHA:    if(!aresetn)begin
   // MSHA:    end
   // MSHA:    else begin
   // MSHA:      if(awvalid)begin
   // MSHA:        mem_awid 	[i]	  = awid  	;	
   // MSHA:        `uvm_info("mem_awid",$sformatf("mem_awid[%0d]=%0d",i,mem_awid[i]),UVM_HIGH)
   // MSHA:        `uvm_info("mem_awid",$sformatf("awid=%0d",awid),UVM_HIGH)
   // MSHA:       //data_write_packet.awid = awid   ;
	 // MSHA:  	    mem_waddr	[i] 	= awaddr	;
   // MSHA:        //data_write_packet.awaddr = awaddr;
	 // MSHA:  	    mem_wlen 	[i]	  = awlen	;	
   // MSHA:        //data_write_packet.awlen = awlen;
	 // MSHA:  	    mem_wsize	[i] 	= awsize	;	
   // MSHA:        //data_write_packet.awsize = awsize;
	 // MSHA:  	    mem_wburst[i] 	= awburst;	
   // MSHA:        //data_write_packet.awburst = awburst;
	 // MSHA:  	    mem_wlock	[i] 	= awlock	;	
   // MSHA:        //data_write_packet.awlock = awlock;
	 // MSHA:  	    mem_wcache[i] 	= awcache;	
   // MSHA:        //data_write_packet.awcache = awcache;
	 // MSHA:  	    mem_wprot	[i] 	= awprot	;	
   // MSHA:        //data_write_packet.awprot = awprot;
	 // MSHA:  	    i = i+1;
   // MSHA:      end
   // MSHA:        for(int k=0;k<$size(mem_awid);k++) begin
   // MSHA:          data_write_packet.awid = mem_awid[k];
   // MSHA:          data_write_packet.awaddr = mem_waddr[k];
   // MSHA:          data_write_packet.awlen = mem_wlen[k];
   // MSHA:          data_write_packet.awsize = mem_wsize[k];
   // MSHA:          data_write_packet.awburst = mem_wburst[k];
   // MSHA:          data_write_packet.awlock = mem_wlock[k];
   // MSHA:          data_write_packet.awcache = mem_wcache[k];
   // MSHA:          data_write_packet.awprot = mem_wprot[k];
   // MSHA:         //  data_write_packet.awid = awid;
   // MSHA:         //  data_write_packet.awaddr = awaddr;
   // MSHA:         //  data_write_packet.awlen = awlen;
   // MSHA:         //  data_write_packet.awsize = awsize;
   // MSHA:         //  data_write_packet.awburst = awburst;
   // MSHA:         //  data_write_packet.awlock = awlock;
   // MSHA:         //  data_write_packet.awcache = awcache;
   // MSHA:         //  data_write_packet.awprot = awprot;
   // MSHA:       `uvm_info(name,$sformatf("struct_pkt_wr_addr_phase = \n %0p",data_write_packet),UVM_HIGH)
   // MSHA:     end
   // MSHA:   end
  //end

   // data_write_packet.awready=awready;
  endtask

  //-------------------------------------------------------
  // Task: axi4_write_data_phase
  // This task will sample the write data signals
  //-------------------------------------------------------
  task axi4_write_data_phase (inout axi4_write_transfer_char_s data_write_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    `uvm_info(name,$sformatf("data_write_packet=\n%p",data_write_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO WRITE DATA CHANNEL"),UVM_HIGH)
    
    wready=0;
  
  while(wvalid === 0) begin
      @(posedge aclk);
    end

    `uvm_info("SLAVE_DRIVER", $sformatf("DEBUG_MSHA :: outside of wvalid"), UVM_NONE);
    foreach(data_write_packet.wdata[i])begin
    data_write_packet.wdata[i]=wdata[i];
    data_write_packet.wstrb[i]=wstrb[i];
  end

   `uvm_info(name,$sformatf("Before DRIVING WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
    repeat(data_write_packet.no_of_wait_states)begin
      `uvm_info(name,$sformatf("DRIVING WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
      @(posedge aclk);
      wready<=0;
    end
    wready <= 1;

    //write else also
  endtask : axi4_write_data_phase
  //-------------------------------------------------------
  // Task: axi_write_data_phase
  // Samples the write data based on different burst types
  //-------------------------------------------------------

//  task axi4_write_data_phase(axi4_write_transfer_char_s data_write_packet, axi4_transfer_cfg_s struct_cfg);
//
//    @(posedge aclk) begin
//      `uvm_info(name,"INSIDE WRITE_DATA_PHASE",UVM_LOW)
//      repeat(data_write_packet.no_of_wait_states)begin
//        `uvm_info(name,$sformatf("DRIVING WAIT STATES :: %0d",data_write_packet.no_of_wait_states),UVM_HIGH);
//        @(posedge aclk);
//        wready<=0;
//      end
//      assign wready = wvalid;
//
//   // data_write_packet.wready=wready;
//     // wready <= 1;
//
//      if(!aresetn)begin
//      end
//    end
//
//    //FIXED_Burst type
//    
//    @(posedge aclk)begin
//      if(aresetn)begin
//        for(int i = 0,k_t = 0;i<$size(mem_awid);i++)begin
//          if(mem_wburst[i] == WRITE_FIXED)begin
//            for(int j = 0;j<(mem_wlen[i]+1);j = j+1)begin
//              for(int k = 0,k1 = 0;k1<(2**mem_wsize[i]);k1++)begin
//                if(wstrb[k1])begin
//                  data_write_packet.awaddr <= mem_waddr[i]+k-k_t; 
//                  `uvm_info(name,$sformatf("w_addr = %0h",data_write_packet.awaddr),UVM_HIGH);
//                  k++;
//                  @(posedge aclk);
//                end
//                else begin
//                  k++; 
//                  k_t++;
//                  @(posedge aclk);
//                end
//              end
//            end
//          end
//         
//          //INCR Burst type
//
//          else if(mem_wburst[i] == WRITE_INCR)begin 
//             for(int j = 0;j<(mem_wlen[i]+1);j = j+1)begin
//               for(int k = 0,k1 = 0;k1<(2**mem_wsize[i]);k1++)begin
//                 if(wstrb[k1])begin
//                   data_write_packet.awaddr  <= mem_waddr[i]+(j*(2**mem_wsize[i]))+k-k_t;
//                   `uvm_info(name,$sformatf("addr = %0h",data_write_packet.awaddr),UVM_HIGH);
//                   k++;
//                   @(posedge aclk);
//                 end
//                 else begin
//                   k++; 
//                   k_t++;
//                   @(posedge aclk);
//                 end
//               end
//             end
//           end
//           
//         end
//       end
//      end
//      
//      for(int i1 = 0;i1<$size(mem_awid);i1++)begin
//        if(mem_wburst[i1])begin
//          `uvm_info(name,$sformatf("mem_burst[%0d] = %0h",i1,mem_wburst[i1]),UVM_HIGH);
//          for(int n = 0;n<(2**mem_wsize[i1]);n++)begin
//            if(wstrb[n])begin
//              `uvm_info(name,$sformatf("mem_wstrb[%0d] = %0h",n,wstrb[n]),UVM_HIGH);
//              data_write_packet.wdata[i1] = wdata[n*8 +: 8];
//              `uvm_info(name,$sformatf("wdata = %p",data_write_packet.wdata),UVM_HIGH);
//              @(posedge aclk);
//            end
//            else @(posedge aclk);
//          end
//        end
//      end
//  endtask : axi4_write_data_phase

  //-------------------------------------------------------
  // Task: axi4_write_response_phase
  // This task will drive the write response signals
  //-------------------------------------------------------
  
 // task axi4_write_response_phase(axi4_write_transfer_char_s data_write_packet, axi4_transfer_cfg_s
 //   struct_cfg,int valid_delay = 2);
 //   int j;
 //   @(posedge aclk)begin
 //     `uvm_info(name,"INSIDE WRITE RESPONSE PHASE",UVM_LOW)
 //     if(!aresetn)begin
 //     //  bresp = 2'bz;
 //       bvalid = 0;
 //     end
 //     
 //     else begin
 //       //`uvm_info("bid_debug",$sformatf("bid_local=%0d",bid_local),UVM_HIGH)
 //       //`uvm_info("bid_debug",$sformatf("data_write_packet.awid=%0d",data_write_packet.awid),UVM_HIGH)
 //       //`uvm_info("bid_debug",$sformatf("mem_awid[%0d]=%0d",j,mem_awid[j]),UVM_HIGH)
 //       //`uvm_info("bid_debug",$sformatf("bid_local=%0d",bid_local),UVM_HIGH)
 //       //bid  <= mem_awid[i];
 //       if(wready && wvalid)begin
 //       if(std::randomize(bid_local) with {bid_local ==  mem_awid[j];})

 //         //bid  <= mem_awid[i];
 //         bid  = bid_local;
 //       `uvm_info("bid_debug",$sformatf("mem_awid[%0d]=%0d",j,mem_awid[j]),UVM_HIGH)
 //       `uvm_info("bid_debug",$sformatf("bid_local=%0d",bid_local),UVM_HIGH)
 //           bresp <= WRITE_OKAY;
 //           bvalid = 1;
 //           j++;
 //           
 //           repeat(valid_delay-1) begin
 //             @(posedge aclk);
 //           end
 //           bvalid = 0;
 //         
 //         end
 //         //else begin
 //         //  bresp <= 2'bxx;
 //         //  bvalid = 0;
 //        // end
 //       //end
 //     end
 //   end
 // endtask : axi4_write_response_phase

  //-------------------------------------------------------
  // Task: axi4_write_response_phase
  // This task will drive the write response signals
  //-------------------------------------------------------
  task axi4_write_response_phase (inout axi4_write_transfer_char_s data_write_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    `uvm_info(name,$sformatf("data_write_packet=\n%p",data_write_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH)
    `uvm_info(name,$sformatf("DRIVE TO WRITE RESPONSE CHANNEL"),UVM_HIGH)
  
    bid=data_write_packet.bid;
    bresp=data_write_packet.bresp;
    bvalid=1;

    `uvm_info(name,$sformatf("detect_bready = %0d",bready),UVM_HIGH)
    while(bready === 0) begin
      @(posedge aclk);
      data_write_packet.wait_count_write_response_channel++;
      `uvm_info(name,$sformatf("inside_detect_bready = %0d",bready),UVM_HIGH)
    end
    `uvm_info(name,$sformatf("After_loop_of_Detecting_bready = %0d",bready),UVM_HIGH)
 
  endtask : axi4_write_response_phase
  //-------------------------------------------------------
  // Task: axi4_read_address_phase
  // This task will sample the read address signals
  //-------------------------------------------------------
  task axi4_read_address_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    `uvm_info(name,$sformatf("data_read_packet=\n%p",data_read_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("DRIVE TO READ ADDRESS CHANNEL"),UVM_HIGH);
    
    arready <= 0;

    while(arvalid === 0) begin
      @(posedge aclk);
    end

    `uvm_info("SLAVE_DRIVER", $sformatf("DEBUG_MSHA :: outside of arvalid"), UVM_NONE); 
       data_read_packet.arid=arid;
       data_read_packet.araddr=araddr;
       data_read_packet.arlen = arlen;
       data_read_packet.arsize = arsize;
       data_read_packet.arburst = arburst;
       data_read_packet.arlock = arlock;
       data_read_packet.arcache = arcache;
       data_read_packet.arprot = arprot;
     
     repeat(data_read_packet.no_of_wait_states)begin
       `uvm_info(name,$sformatf("DRIVING WAIT STATES :: %0d",data_read_packet.no_of_wait_states),UVM_HIGH);
       @(posedge aclk);
       arready<=0;
     end
     arready<=1;
  
   endtask : axi4_read_address_phase

  //-------------------------------------------------------
  // Task: axi4_read_data_channel_task
  // This task will drive the read data signals
  //-------------------------------------------------------
  task axi4_read_data_phase (inout axi4_read_transfer_char_s data_read_packet, input axi4_transfer_cfg_s cfg_packet);
    @(posedge aclk);
    `uvm_info(name,$sformatf("data_read_packet=\n%p",data_read_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("cfg_packet=\n%p",cfg_packet),UVM_HIGH);
    `uvm_info(name,$sformatf("DRIVE TO READ DATA CHANNEL"),UVM_HIGH);
    
    rid=data_read_packet.rid;
    rdata=data_read_packet.rdata;
    rresp=data_read_packet.rresp;
    rvalid=1;

    while(rready===0) begin
      @(posedge aclk);
      data_read_packet.wait_count_read_data_channel++;
    end
  
  endtask : axi4_read_data_phase

endinterface : axi4_slave_driver_bfm

`endif
