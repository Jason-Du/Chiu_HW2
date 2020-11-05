	`include "../../include/AXI_define.svh"
module write_read_arbitor(
							  clk,
							  rst,
							  ARVALID_M0,
							  ARVALID_M1,
							  AWVALID_M1,
							  read_situation_decode,
							  write_situation_decode,
							  
							  
							  ARVALID_M_0stage1,
							  ARVALID_M_1stage1,
							  AWVALID_M_1stage1
	);
	input              clk;
	input              rst;
	input              ARVALID_M0;
	input              ARVALID_M1;
	input              AWVALID_M1;
	input              write_situation_decode;
	input        [1:0] read_situation_decode;
	
	output logic       ARVALID_M_0stage1;
	output logic       ARVALID_M_1stage1;
	output logic       AWVALID_M_1stage1;
	logic        [2:0] situation;
	logic        [2:0] situation2;
	//read_situation={ARVALID_M0,ARVALID_M1};
	logic              cs;
	logic              ns;


	always_ff@(posedge clk)
	begin
		if(rst==1'b0)
		begin
			cs=1'b0;
		end
		else
		begin
			cs=ns;
		end
	end
	always_comb
	begin
		case(cs)
			1'b0:
			begin
				ns=(ARVALID_M0||ARVALID_M1||AWVALID_M1)?1'b1:1'b0;
			end
			1'b1:
			begin
				ns=(read_situation_decode[0]||read_situation_decode[1]||write_situation_decode)?1'b1:1'b0;
			end
		endcase
	end

//read  situation={ARVALID_M0,ARVALID_M1}    write;
//	situation={ARVALID_M0,ARVALID_M1}    write;
	always_comb
	begin

		if(rst==1'b0)
		begin
			ARVALID_M_0stage1=1'b0;
			ARVALID_M_1stage1=1'b0;
			AWVALID_M_1stage1=1'b0;
			situation2=3'b000;
			situation=3'b000;
		end
		else if (cs==1'b0)
		begin
			situation={ARVALID_M0,
			ARVALID_M1,
			AWVALID_M1
			};
			case(situation)
				3'b000:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=1'b0;
				end
				3'b001:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
				3'b010:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=ARVALID_M1;
					AWVALID_M_1stage1=1'b0;
				end
				3'b011:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
				3'b100:
				begin
					ARVALID_M_0stage1=ARVALID_M0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=1'b0;
				end
				3'b101:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
				3'b110:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=ARVALID_M1;
					AWVALID_M_1stage1=1'b0;
				end
				3'b111:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
			endcase
		end
	end
endmodule
/*
		else if (cs==1'b1)
		begin
			situation2={read_situation_decode,write_situation_decode};
			case(situation2)
				3'b000:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=1'b0;
				end
				3'b001:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
				3'b010:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=ARVALID_M1;
					AWVALID_M_1stage1=1'b0;
				end
				3'b011:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
				3'b100:
				begin
					ARVALID_M_0stage1=ARVALID_M0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=1'b0;
				end
				3'b101:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
				3'b110:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=ARVALID_M1;
					AWVALID_M_1stage1=1'b0;
				end
				3'b111:
				begin
					ARVALID_M_0stage1=1'b0;
					ARVALID_M_1stage1=1'b0;
					AWVALID_M_1stage1=AWVALID_M1;
				end
			endcase
		end
*/
