`timescale 1ns/10ps
`include "../include/AXI_define.svh"
module master_write#(
	parameter slaveid        =4'b0001,
	parameter masterid       =4'b0001,
	parameter default_slaveid =4'b0010)(
	clk,
	rst,
	cpu_write_signal,
	cpu_write_data,
	address,
	web,
	
	cpu_write_pause,

	AWID_M,
	AWADDR_M,
	AWLEN_M,
	AWSIZE_M,
	AWBURST_M,
	AWVALID_M,
	//WRITE DATA1
	WDATA_M,
	WSTRB_M,
	WLAST_M,
	WVALID_M,
	//WRITE RESPONSE1
	BREADY_M,
	//WRITE DATA1




	WREADY_M,
	//WRITE ADDRESS1
	AWREADY_M,
	//WRITE RESPONSE1
	BID_M,
	BRESP_M,
	BVALID_M

);
//-------------SYSTEM
	input                              clk;
	input                              rst;
	input                              cpu_write_signal;
	input        [                3:0] web;
	input        [               31:0] cpu_write_data;
	input        [               31:0] address;
	
	output logic                       cpu_write_pause;






//-------------AXI WRITE PORT
	output logic [  `AXI_ID_BITS-1:0] AWID_M;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_M;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_M;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M;
	output logic [               1:0] AWBURST_M;
	output logic                      AWVALID_M;
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_M;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_M;
	output logic                      WLAST_M;
	output logic                      WVALID_M;
	//WRITE RESPONSE1
	output logic                      BREADY_M;
	//WRITE DATA1
	
	
	
	input                             WREADY_M;
	//WRITE ADDRESS1
	input                             AWREADY_M;
	//WRITE RESPONSE1
	input        [  `AXI_ID_BITS-1:0] BID_M;
	input        [               1:0] BRESP_M;
	input                             BVALID_M;
	
	
	
	logic         [                1:0]cs;
	logic         [                1:0]ns;
	
	
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
				if(cpu_write_signal)
				begin
					ns=2'b01;
					cpu_write_pause=1'b0;	
				end
				else
				begin
					ns=2'b00;
					cpu_write_pause=1'b0;
				end
				AWID_M=default_slaveid;
				AWADDR_M=32'd0;
				
				AWVALID_M=1'b0;
					//WRITE DATA1
				WDATA_M=32'd0;
				WSTRB_M=cpu_write_signal?web:4'b1111;
				WLAST_M=1'b0;
				WVALID_M=1'b0;
					//WRITE RESPONSE1
				BREADY_M=1'b0;
			end
			2'b01:
			begin
				if(AWREADY_M==1'b1)
				begin
					ns=2'b10;
				end
				else
				begin
					ns=2'b01;
				end
				AWID_M=slaveid;
				AWADDR_M=address;
				
				AWVALID_M=1'b1;
					//WRITE DATA1
				WDATA_M=32'd0;
				WSTRB_M=WSTRB_M;
				WLAST_M=1'b0;
				WVALID_M=1'b0;
					//WRITE RESPONSE1
				BREADY_M=1'b0;
				cpu_write_pause=1'b1;	
			end
			2'b10:
			begin
				if(WREADY_M==1'b1)
				begin
					ns=2'b11;
				end
				else
				begin
					ns=2'b10;
				end
				AWID_M=AWID_M;
				AWADDR_M=AWADDR_M;
				
				AWVALID_M=1'b0;
					//WRITE DATA1
				WDATA_M=WREADY_M?cpu_write_data:32'd0;
				WSTRB_M=WSTRB_M;
				WLAST_M=1'b1;
				WVALID_M=1'b1;
					//WRITE RESPONSE1
				BREADY_M=1'b0;
				cpu_write_pause=1'b1;					
			end				
			2'b11:
			begin
				if(BVALID_M==1'b1 && BRESP_M==2'b00 && BID_M==masterid)
				begin
					ns=2'b00;
				end
				else
				begin
					ns=2'b11;
				end
				AWID_M=AWID_M;
				AWADDR_M=AWADDR_M;
				
				AWVALID_M=1'b0;
					//WRITE DATA1
				WDATA_M=WDATA_M;
				WSTRB_M=WSTRB_M;
				WLAST_M=1'b0;
				WVALID_M=1'b0;
					//WRITE RESPONSE1
				BREADY_M=1'b1;
				cpu_write_pause=1'b1;	
			end			
		endcase
	end
	always_comb
	begin
		AWLEN_M  =4'd0;
		AWSIZE_M =3'd2;
		AWBURST_M=2'd1;
	end
	
	
endmodule
