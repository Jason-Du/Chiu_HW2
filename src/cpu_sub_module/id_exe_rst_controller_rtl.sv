`timescale 1ns/10ps

module id_exe_rst_controller(
						local_rst,
						global_rst,
						pc_jump_control,
						pc_stall,
						enable_jump,
						
						rst_data
						);
output logic rst_data;

input        pc_jump_control;
input        local_rst;
input        global_rst;
input        pc_stall;
input        enable_jump;

always_comb
begin
	rst_data=global_rst?1'b1: ( pc_stall  ? 1'b1: ( enable_jump ? ( pc_jump_control ? local_rst:1'b0) :1'b0)  );

end

endmodule