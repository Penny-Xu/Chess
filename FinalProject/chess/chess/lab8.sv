//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             //input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [15:0] keycode;
    
    assign Clk = CLOCK_50;
    assign {Reset_h} = ~(KEY[0]);  // The push buttons are active low
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w,hpi_cs;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)   
                            //.OTG_INT(OTG_INT)
    );
     
     //The connections for nios_system might be named different depending on how you set up Qsys
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n((KEY[0])), 
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );
    
    //Fill in the connections for the rest of the modules 
	 
	 
	 logic [9:0] DrawX, DrawY, BallX, BallY, BallS;
	
	 logic [11:0] piecesIn[64], piecesOut[64];
	 assign piecesIn[64] =  {12'b000000000100, 12'b000000010000, 12'b000000001000, 12'b000000000010, 12'b000000000001, 12'b000000001000, 12'b000000010000, 12'b000000000100,
							  12'b000000100000, 12'b000000100000, 12'b000000100000, 12'b000000100000, 12'b000000100000, 12'b000000100000, 12'b000000100000, 12'b000000100000,
							  12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000,
							  12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000,
							  12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000,
							  12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000, 12'b000000000000,
							  12'b100000000000, 12'b100000000000, 12'b100000000000, 12'b100000000000, 12'b100000000000, 12'b100000000000, 12'b100000000000, 12'b100000000000,
							  12'b000100000000, 12'b010000000000, 12'b001000000000, 12'b000010000000, 12'b000001000000, 12'b001000000000, 12'b010000000000, 12'b000100000000} 
		
	 
	 GameBoard gameboard_inst (.clk(Clk), .reset(Reset_h),
                     .piecesIn(piecesIn),
						   .piecesOut(piecesOut));
	 
	 VGA_controller vga_controller_instance(.Clk(Clk),      
                                           .Reset(Reset_h),       // reset signal
														 .VGA_HS(VGA_HS),      // Horizontal sync pulse.  Active low
                                           .VGA_VS(VGA_VS),      // Vertical sync pulse.  Active low
                                           .VGA_CLK(VGA_CLK),     // 25 MHz VGA clock output
                                           .VGA_BLANK_N(VGA_BLANK_N), // Blanking interval indicator.  Active low.
                                           .VGA_SYNC_N(VGA_SYNC_N),  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                                        // but the video DAC on the DE2 board requires an input for it.
														 .DrawX(DrawX),       // horizontal coordinate
                                           .DrawY(DrawY));
	 
    ball ball_instance(.Reset(~(KEY[1])), 
                       .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
                       .BallX(BallX), .BallY(BallY), .BallS(BallS), .keycode(tempkeycode)); // Ball coordinates and size
					
    
    color_mapper color_instance(
                                .DrawX(DrawX), .DrawY(DrawY), .pieceSelect(piecesOut[48])      // Coordinates of current drawing pixel
                                .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B)); // VGA RGB output
										  
	 
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
