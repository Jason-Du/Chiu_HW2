`timescale 1ns/10ps
`include "../include/AXI_define.svh"

module master_read #(
	parameter slaveid        =4'b0001,
	parameter masterid       =4'b0001,
	parameter default_slaveid =4'b0010)(
	clk,
	rst,
	cpu_read_signal,
	im_read_pause,
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
	input                             im_read_pause;

	
	
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
	
	logic        [               2:0] cs;
	logic        [               2:0] ns;
	logic        [              31:0] read_data_register_out;
	always_ff@(posedge clk or negedge rst)
	begin
		if (rst==1'b0)
		begin
			cs<=3'b000;
		end
		else
		begin
			cs<=ns;
		end
	end
	always_ff@(posedge clk or negedge rst)
	begin
		if (rst==1'b0)
		begin
			read_data_register_out=32'd0;
		end
		else
		begin
			read_data_register_out=read_data;
		end
	end
	always_comb
	begin
		case(cs)
			3'b000:
			begin
				if(cpu_read_signal)
				begin
					ns=3'b001;
					read_pause_cpu=1'b1;
					ARADDR_M =address;
				end
				else
				begin
					ns=3'b000;
					read_pause_cpu=1'b0;
					ARADDR_M =32'd0;
				end
				ARID_M   =default_slaveid;
				//mofify
				//ARADDR_M =32'd0;
				ARVALID_M=1'b0;
				RREADY_M =1'b0;
				read_data=32'd0;
			end
			3'b001:
			begin
				if(ARREADY_M==1'b1)
				begin
					ns=3'b010;
				end
				else
				begin
					ns=3'b001;
				end
				ARID_M   =slaveid;
				ARADDR_M =address;
				ARVALID_M=1'b1;
				RREADY_M =1'b0;
				read_pause_cpu=1'b1;
				read_data=32'd0;
			end
			3'b010:
			begin
				if (RLAST_M==1'b1)
				begin
					ns=3'b100;
				end
				else
				begin
					ns=3'b010;
				end
				ARID_M   =slaveid;
				ARADDR_M =address;
				ARVALID_M=1'b0;
				RREADY_M =1'b1;
				read_data= (RRESP_M==2'b00 && RVALID_M==1'b1)?RDATA_M:32'd0;
				read_pause_cpu=1'b1;
			end
			//modify state
			3'b100:
			begin
				ARID_M   =slaveid;
				ARADDR_M =address;
				ARVALID_M=1'b0;
				RREADY_M =1'b1;
				read_data= read_data_register_out;
				read_pause_cpu=1'b0;
				ns=	im_read_pause?3'b100:3'b000;				
			end
			default:
			begin
				ARID_M   =default_slaveid;
				ARADDR_M =32'd0;
				ARVALID_M=1'b0;
				RREADY_M =1'b0;
				read_pause_cpu=1'b0;
				read_data=32'd0;
				ns=3'b000;
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
