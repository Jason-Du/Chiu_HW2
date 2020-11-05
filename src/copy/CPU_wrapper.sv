`timescale 1ns/10ps
`include "../include/AXI_define.svh"
`include"master_read_rtl.sv"
`include"master_write_rtl.sv"
`include"CPU.sv"
parameter im_id     =4'b0000;
parameter dm_id     =4'b0001;
parameter default_id=4'b0010;
module CPU_wrapper(
	clk,
	rst,
	//im_read_signal,
	//dm_read_signal,
	//dm_write_signal,
	//dm_write_data,
	//dm_address,
	//im_address,
	//dm_web,
	
	
	//dm_pause,
	//im_pause,
	//dm_read_data,
	//im_read_data,

	AWID_M1,
	AWADDR_M1,
	AWLEN_M1,
	AWSIZE_M1,
	AWBURST_M1,
	AWVALID_M1,
	//WRITE DATA1
	WDATA_M1,
	WSTRB_M1,
	WLAST_M1,
	WVALID_M1,
	//WRITE RESPONSE1
	BREADY_M1,
	//WRITE DATA1



	WREADY_M1,
	//WRITE ADDRESS1
	AWREADY_M1,
	//WRITE RESPONSE1
	BID_M1,
	BRESP_M1,
	BVALID_M1,
	
	
	
	//READ ADDRESS0
	ARID_M0,
	ARADDR_M0,
	ARLEN_M0,
	ARSIZE_M0,
	ARBURST_M0,
	ARVALID_M0,
	//READ ADDRESS1
	ARID_M1,
	ARADDR_M1,
	ARLEN_M1,
	ARSIZE_M1,
	ARBURST_M1,
	ARVALID_M1,
	//READ DATA1
	RREADY_M1,
	//READ DATA0	
	RREADY_M0,
	
	
	//READ ADDRESS0
	ARREADY_M0,
	//READ ADDRESS1
	ARREADY_M1,
	//READ DATA1
	RID_M1,
	RDATA_M1,
	RRESP_M1,
	RLAST_M1,
	RVALID_M1,
	//READ DATA0
	RID_M0,
	RDATA_M0,
	RRESP_M0,
	RLAST_M0,
	RVALID_M0

				);
	//------------------------WRITE PORT AXI -----------------
	//WRITE ADDRESS1
	output logic [  `AXI_ID_BITS-1:0] AWID_M1;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_M1;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
	output logic [               1:0] AWBURST_M1;
	output logic                      AWVALID_M1;
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_M1;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
	output logic                      WLAST_M1;
	output logic                      WVALID_M1;
	//WRITE RESPONSE1
	output logic                      BREADY_M1;
	//WRITE DATA1
	
	
	
	input                             WREADY_M1;
	//WRITE ADDRESS1
	input                             AWREADY_M1;
	//WRITE RESPONSE1
	input        [  `AXI_ID_BITS-1:0] BID_M1;
	input        [               1:0] BRESP_M1;
	input                             BVALID_M1;
	
	

//---------------------------------READ PORT AXI -------------------------
	//READ ADDRESS1
	input                             ARREADY_M1;
	//READ ADDRESS0
	input                             ARREADY_M0;
	//READ DATA0
	input        [  `AXI_ID_BITS-1:0] RID_M0;
	input        [`AXI_DATA_BITS-1:0] RDATA_M0;
	input        [               1:0] RRESP_M0;
	input                             RLAST_M0;
	input                             RVALID_M0;
	//READ DATA1
	input        [  `AXI_ID_BITS-1:0] RID_M1;
	input        [`AXI_DATA_BITS-1:0] RDATA_M1;
	input        [               1:0] RRESP_M1;
	input                             RLAST_M1;
	input                             RVALID_M1;
	
	
	
	//READ ADDRESS0
	output logic [  `AXI_ID_BITS-1:0] ARID_M0;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_M0;//1
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;//1
	output logic [               1:0] ARBURST_M0;//0
	output logic                      ARVALID_M0;
	//READ ADDRESS1
	output logic [  `AXI_ID_BITS-1:0] ARID_M1;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_M1;//1
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;//0
	output logic [               1:0] ARBURST_M1;//1
	output logic                      ARVALID_M1;
	//READ DATA0
	output logic                      RREADY_M0;
	//READ DATA1
	output logic                      RREADY_M1;

	
	
	
	//---------------------------DESIGN
	input                             clk;
	input                             rst;	
	
	
	
	

	

	logic        [              31:0] dm_write_data;
	logic                             cpu_pause;
	logic        [              31:0] dm_read_data;
	logic        [              31:0] im_read_data;
	
	logic                             dm_read_signal;
	logic                             im_read_signal;
	logic                             dm_write_signal;
	logic                             dm_read_pause;
	logic                             im_read_pause;
	logic                             dm_write_pause;
	logic        [              31:0] dm_address;
	logic        [              31:0] im_address;
	//logic                             im_write_pause;
	logic                             im_write_signal;
	logic        [               3:0] dm_web;
	//logic        [              31:0] im_write_data;
	//logic        [               3:0] im_web;
	always_comb
	begin
		cpu_pause=(dm_read_pause||dm_write_pause||im_read_pause)?1'b1:1'b0;
	end
	
	master_read dmread(
	.clk(clk),
	.rst(rst),
	.cpu_read_signal(dm_read_signal),
	.address(dm_address),
	
	.read_data(dm_read_data),
	.read_pause_cpu(dm_read_pause),

	
	
	//READ ADDRESS0
	.ARID_M(ARID_M1),
	.ARADDR_M(ARADDR_M1),
	.ARLEN_M(ARLEN_M1),
	.ARSIZE_M(ARSIZE_M1),
	.ARBURST_M(ARBURST_M1),
	.ARVALID_M(ARVALID_M1),
	//READ DATA0	
	.RREADY_M(RREADY_M1),
	
	
	//READ ADDRESS0
	.ARREADY_M(ARREADY_M1),
	//READ DATA0
	.RID_M(RID_M1),//unuse
	.RDATA_M(RDATA_M1),
	.RRESP_M(RRESP_M1),
	.RLAST_M(RLAST_M1),
	.RVALID_M(RVALID_M1)

	);
	
	master_read #(im_id,im_id,default_id)imread(
	.clk(clk),
	.rst(rst),
	.cpu_read_signal(im_read_signal),
	.address(im_address),
	
	.read_data(im_read_data),
	.read_pause_cpu(im_read_pause),

	
	
	//READ ADDRESS0
	.ARID_M(ARID_M0),
	.ARADDR_M(ARADDR_M0),
	.ARLEN_M(ARLEN_M0),
	.ARSIZE_M(ARSIZE_M0),
	.ARBURST_M(ARBURST_M0),
	.ARVALID_M(ARVALID_M0),
	//READ DATA0	
	.RREADY_M(RREADY_M0),
	
	
	//READ ADDRESS0
	.ARREADY_M(ARREADY_M0),
	//READ DATA0
	.RID_M(RID_M0),//unuse
	.RDATA_M(RDATA_M0),
	.RRESP_M(RRESP_M0),
	.RLAST_M(RLAST_M0),
	.RVALID_M(RVALID_M0)
	);
	
	
	master_write dmwrite(
	.clk(clk),
	.rst(rst),
	.cpu_write_signal(cpu_write_signal),
	.cpu_write_data(dm_write_data),
	.address(dm_address),
	.web(web),
	
	.cpu_write_pause(dm_write_pause),

	.AWID_M(AWID_M1),
	.AWADDR_M(AWADDR_M1),
	.AWLEN_M(AWLEN_M1),
	.AWSIZE_M(AWSIZE_M1),
	.AWBURST_M(AWBURST_M1),
	.AWVALID_M(AWVALID_M1),
	//WRITE DATA1
	.WDATA_M(WDATA_M1),
	.WSTRB_M(WSTRB_M1),
	.WLAST_M(WLAST_M1),
	.WVALID_M(WVALID_M1),
	//WRITE RESPONSE1
	.BREADY_M(BREADY_M1),
	//WRITE DATA1
	.WREADY_M(WREADY_M1),
	//WRITE ADDRESS1
	.AWREADY_M(AWREADY_M1),
	//WRITE RESPONSE1
	.BID_M(BID_M1),
	.BRESP_M(BRESP_M1),
	.BVALID_M(BVALID_M1)

);
CPU CPU1(
			.clk(clk),
			.rst(rst),
			.im_dataout(im_read_data),
			.dm_dataout(dm_read_data),
			.bus_stall(cpu_pause),


//			im_cs(),
//			im_oe(),
//			im_web(),
			.im_addr(im_address),
			.im_read_mem(im_read_signal),
//   		im_datain(),
//			dm_cs(),
//			dm_oe(),
			.dm_web(dm_web),
			.dm_addr(dm_address),
			.dm_datain(dm_write_data),
			.dm_write_mem(dm_write_signal),
			.dm_read_mem(dm_read_signal)
				);






endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
