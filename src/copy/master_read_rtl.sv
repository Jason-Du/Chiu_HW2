`timescale 1ns/10ps
`include "../include/AXI_define.svh"

module master_read #(
	parameter slaveid        =4'b0001,
	parameter masterid       =4'b0001,
	parameter default_slaveid =4'b0010)(
	clk,
	rst,
	cpu_read_signal,
	address,
	
	read_data,
	read_pause_cpu,

	
	
	//READ ADDRESS0
	ARID_M,
	ARADDR_M,
	ARLEN_M,     
	ARSIZE_M,
	ARBURST_M,
	ARVALID_M,
	//READ DATA0	
	RREADY_M,
	
	
	//READ ADDRESS0
	ARREADY_M,
	//READ DATA0
	RID_M,//unuse
	RDATA_M,
	RRESP_M,
	RLAST_M,
	RVALID_M

);
	//system
	input                             clk;
	input                             rst;	
	input                             cpu_read_signal;
    input        [              31:0] address; 	
	

	
	
	logic        [               1:0] dmcs;
	logic        [               1:0] dmns;
	logic        [               1:0] imcs;
	logic        [               1:0] imns;
	

	input                             ARREADY_M;
	//READ DATA0
	input        [  `AXI_ID_BITS-1:0] RID_M;
	input        [`AXI_DATA_BITS-1:0] RDATA_M;
	input        [               1:0] RRESP_M;
	input                             RLAST_M;
	input                             RVALID_M;
	
	
	
	//READ ADDRESS0
	output logic [  `AXI_ID_BITS-1:0] ARID_M;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_M;//1
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M;//2
	output logic [               1:0] ARBURST_M;//0
	output logic                      ARVALID_M;
	//READ DATA0
	output logic                      RREADY_M;
	//system
	output logic [              31:0] read_data;      
	output logic                      read_pause_cpu;
	
	logic        [               1:0] cs;
	logic        [               1:0] ns;
	
	always_ff@(posedge clk)
	begin
		if (rst==1'b0)
		begin
			cs<=2'b00;
		end
		else
		begin
			cs<=ns;
		end
	end
	always_comb
	begin
		case(cs)
			2'b00:
			begin
				if(cpu_read_signal)
				begin
					dmns=2'b01;
					read_pause_cpu=1'b1;
				end
				else
				begin
					ns=2'b00;
					read_pause_cpu=1'b0;
				end
				ARID_M   =default_slaveid;
				ARADDR_M =32'd0;
				ARVALID_M=1'b0;
				RREADY_M =1'b0;
				
				read_data=32'd0;
			end
			2'b01:
			begin
				if(ARREADY_M==1'b1)
				begin
					ns=2'b10;
				end
				else
				begin
					ns=2'b01;
				end
				ARID_M   =slaveid;
				ARADDR_M =address;
				ARVALID_M=1'b1;
				RREADY_M =1'b0;
				read_pause_cpu=1'b1;
				read_data=32'd0;
			end
			2'b10:
			begin
				if (RLAST_M==1'b1)
				begin
					ns=2'b00;
				end
				else
				begin
					ns=2'b10;
				end
				ARID_M   =slaveid;
				ARADDR_M =address;
				ARVALID_M=1'b0;
				RREADY_M =1'b1;
				read_data= (RRESP_M==2'b00 && RVALID_M==1'b1 && RID_M==masterid)?RDATA_M:32'd0;
				read_pause_cpu=1'b1;
			end
			default:
			begin
				ARID_M   =default_slaveid;
				ARADDR_M =32'd0;
				ARVALID_M=1'b0;
				RREADY_M =1'b0;
				read_pause_cpu=1'b0;
				read_data=32'd0;
				
			end
		endcase
	end
	
	always_comb
	begin
		ARLEN_M  =4'd0;
		ARSIZE_M =3'd2;
		ARBURST_M=2'd1;
	end
	
	endmodule
