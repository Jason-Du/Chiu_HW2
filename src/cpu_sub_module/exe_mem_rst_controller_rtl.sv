`timescale 1ns/10ps
module exe_mem_rst_controller(
						local_rst,
						global_rst,
						pc_jump_control,
						enable_jump,
						
						rst_data
						);
output logic rst_data;

input  logic pc_jump_control;
input  logic local_rst;
input  logic global_rst;
input  logic enable_jump;

always_comb
begin
	rst_data=global_rst?1'b1:( enable_jump ? ( pc_jump_control ? local_rst:1'b0) :1'b0);
end

endmodule