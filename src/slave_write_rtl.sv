`timescale 1ns/10ps
`include"../include/AXI_define.svh"
module slave_write(

	clk,
	rst,
	AWID,
	AWADDR,
	AWLEN,
	AWSIZE,
	AWBURST,
	AWVALID,
	AWREADY,
	//WRITE DATA
	WDATA,
	WSTRB,
	WLAST,
	WVALID,
	WREADY,
	//WRITE RESPONSE
	BID,
	BRESP,
	BVALID,
	BREADY,
	WEB,
	A,
	DI,
	slave_id
	);
	input                             clk;
	input                             rst;
	input        [ `AXI_IDS_BITS-1:0] AWID;
	input        [`AXI_ADDR_BITS-1:0] AWADDR;
	input        [ `AXI_LEN_BITS-1:0] AWLEN;
	input        [`AXI_SIZE_BITS-1:0] AWSIZE;
	input        [               1:0] AWBURST;
	input                             AWVALID;
	input        [               7:0] slave_id;
	
	//WRITE DATA
	input        [`AXI_DATA_BITS-1:0] WDATA;
	input        [`AXI_STRB_BITS-1:0] WSTRB;
	input                             WLAST;
	input                             WVALID;
	input                             BREADY;
	output logic                      WREADY;
	output logic                      AWREADY;
	//WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] BID;
	output logic [              1:0] BRESP;
	output logic                     BVALID;
	output logic [              3:0] WEB;
	output logic [             13:0] A;
	output logic [             31:0] DI;
	logic        [              2:0] cs;
	logic        [              2:0] ns;
	logic                            AWVALID_register_out;
	logic                            WVALID_register_out;
	logic        [              2:0] WEB_out;
	logic        [             13:0] A_out;
	logic        [             31:0] address;
	logic        [             31:0] address_register_out;
always_ff(posedge clk or negedge rst)
begin
	if(rst==1'b0)
	begin
		AWVALID_register_out<=1'b0;
		WVALID_register_out<=1'b0;
		WEB_out<=4'b1111;
		A_out<=32'd0;
		address_register_out<=32'd0;
		B
	end
	else
	begin
		AWVALID_register_out<=AWVALID;
		WEB_out<=WEB;
		WVALID_register_out<=WVALID;
		A_out<=A;
		address_register_out<=address;
	end
end

always_ff(posedge clk or negedge rst)
begin
	if(rst==1'b0)
	begin
		cs<=3'b000;
	end
	else
	begin
		cs<=ns;
	end
end
always_comb
begin
	case(cs):
	3'b000:
	begin
		WREADY=1'b0;
		AWREADY=AWVALID_register_out?1'b1:1'b0;
		BID=slave_id;
		BRESP=2'b00;
		BVALID=1'b0;
		WEB=4'b1111;
		A=AWVALID_register_out?AWADDR[14:0]:14'd0;
		DI=32'd0;
		ns=AWVALID?3'b001:3'b000;
		address=address_register_out?AWADDR:32'd0;
	end
	3'b001:
	begin
		WREADY=WVALID_register_out?1'b1:1'b0;
		AWREADY=AWVALID?1'b1:1'b0;
		BID=slave_id;
		BRESP=2'b00;
		BVALID=1'b0;
		WEB=WVALID_register_out?WSTRB:4'b1111;
		A=A_out;
		DI=WVALID_register_out?WDATA:32d'0;
		ns=WVALID?3'b010:3'b001;
		address=address_register_out
	end
	3'b010:
	begin
		WREADY =WVALID?1'b1:1'b0;
		AWREADY=1'b0;
		BID    =slave_id;
		BRESP  =(address_register_out[31:16]=={8'b00000000,slave_id})?2'b00:2'11;
		BVALID =1'b1;
		WEB    =4'b1111;
		A      =A_out;
		DI     =32'd0;
		ns     =BREADY?3'b000:3'b010;
		address=address_register_out;
	end
	/*
	3'b011:
	begin
		WREADY=1'b0;
		AWREADY=1'b0;
		BID=slave_id;
		BRESP=2'b00
		BVALID=1'b0;
		WEB=4'b1111;
		A=A_out;
		DI=32'd0;
		ns=
		address=address_register_out;
	end
	3'b100:
	begin
		WREADY=1'b0;
		AWREADY=;
		BID=slave_id;
		BRESP=2'b00;
		BVALID=;
		WEB=;
		A=;
		DI=;
		ns=
		address=address_register_out;
	end
	*/
	default:
	begin
		WREADY=1'b0;
		AWREADY=;
		BID=slave_id;
		BRESP=2'b00;
		BVALID=;
		WEB=4'b1111;
		A=14'd0;
		DI=32'd0;
		ns=3'b000;
		address=32'd0;
	end
	
end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
endmodule