`timescale 1ns/10ps
`include"../include/AXI_define.svh"
//dm
module slave_read(
	clk,
	rst,
	ARID,
	ARADDR,
	ARLEN,
	ARSIZE,
	ARBURST,
	ARVALID,
	ARREADY,
	//READ DATA
	RID,
	RDATA,
	RRESP,
	RLAST,
	RVALID,
	RREADY,
	OE,
	A,
	DO,
	slave_id;
);
	input        [ `AXI_IDS_BITS-1:0] ARID;
	input        [`AXI_ADDR_BITS-1:0] ARADDR;
	input        [ `AXI_LEN_BITS-1:0] ARLEN;
	input        [`AXI_SIZE_BITS-1:0] ARSIZE;
	input        [               1:0] ARBURST;
	input                             ARVALID;
	input        [              31:0] DO;
	input        [               7:0] slave_id;
	output logic                      ARREADY;
	//READ DATA
	output logic [ `AXI_IDS_BITS-1:0] RID;
	output logic [`AXI_DATA_BITS-1:0] RDATA;
	output logic [               1:0] RRESP;
	output logic                      RLAST;
	output logic                      RVALID;
	output logic                      OE;
	output logic [              13:0] A;
	input                             RREADY;
	
	logic        [               1:0] cs;
	logic        [               1:0] ns;
	logic                             ARVALID_register_out;
	logic        [              31:0] A_register_out;
	logic        [              31:0] RDATA_out;
	logic        [              31:0] address;
	logic        [              31:0] address_register_out;
always_ff(posedge clk or negedge rst)
begin
	if(rst==1'b0)
	begin
		cs<=2'b00;
	end
	else
	begin
		cs<=ns;
	end
end

always_ff(posedge clk or negedge rst)
begin
	if(rst==1'b0)
	begin
		ARVALID_register_out<=1'b0;
		A_register_out<=32'd0;
		RDATA_out<=32'd0;
		address_register_out<=32'd0;

	end
	else
	begin
		ARVALID_register_out<=ARVALID;
		A_register_out<=A;
		RDATA_out<=RDATA;
		address_register_out<=address;
	end
end

always_comb
begin
	if(rst==1'b0)
	begin
		ARREADY=1'b0;
		RID=8'd0;
		RDATA=32'd0;
		RRESP=2'b00;
		RLAST=1'b0;
		RVALID=1'b0;
		ns=2'b00;
		OE=1'b0;
		A=14'd0;
	end
	else
	begin
		case(cs)
			2'b00:
			begin:get_vaild_signal
				ARREADY=ARVALID_register_out?1'b1:1'b0;
				RID=slave_id;
				RDATA=32'd0;
				RRESP=2'b00;
				RLAST=1'b0;
				RVALID=1'b0;
				ns=ARVALID?2'b01:b00;
				OE=ARVALID_register_out?1'b1:1'b0;
				A=ARVALID_register_out?ARADDR[14:0]:14'd0;
				address=ARVALID_register_out?ARADDR:32'd0;
			end
			2'b01:
			begin:get_data
				ARREADY=ARVALID?1'b1:1'b0;
				RID=slave_id;
				RDATA=DO;
				RRESP=2'b00;
				RLAST=1'b0;
				RVALID=1'b0;	
				ns=2'b10;				
				OE=1'b1;
				A=A_register_out;
				address=address_register_out;
			end
			2'b10:
			begin
				ARREADY=1'b0;
				RID=slave_id;
				RDATA=RDATA_out;
				RRESP=(address_register_out[31:16]=={8'b00000000,slave_id})?2'b00:2'b11;
				RLAST=1'b1;
				RVALID=1'b1;		
				ns=RREADY?2'b00:2'b10;			
				OE=1'b1;
				A=A_register_out;
				address=address_register_out;				
			end
			default:
			begin
				ARREADY=1'b0;
				RID=slave_id;
				RDATA=32'd0;
				RRESP=2'b00;
				RLAST=1'b0;
				RVALID=1'b0;
				ns=2'b00;			
				OE=1'b0;
				A=14'd0;
				address=32'd0;
			end
		endcase		
	end
end

endmodule


