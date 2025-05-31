
TESTBENCH PART :
`timescale 1ns/1ps
module top_module_tb;
 reg clk;
 reg rst;
 reg [3:0] keypad_input;
 reg [2:0] direction_input;
 reg [3:0] color_input;
 reg [7:0] pattern_input;
 reg [3:0] code_input;
 reg [3:0] final_key_input;
 wire vault_escape;
 wire all_done;
 // Instantiate the DUT
 top_module dut (
 .clk(clk),
 .rst(rst),
 .keypad_input(keypad_input),
 .direction_input(direction_input),
 .color_input(color_input),
 .pattern_input(pattern_input),
 .code_input(code_input),
 .final_key_input(final_key_input),
 .vault_escape(vault_escape),
 .all_done(all_done)
 );
 // Clock generation: 10ns period
 initial clk = 0;
 always #5 clk = ~clk;
 // VCD dump
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars(0, top_module_tb);
 end
 initial begin
 // Initialize inputs
 rst = 1;
 keypad_input = 4'b0000;
 direction_input = 3'b000;
 color_input = 4'b0000;
 pattern_input = 8'h00;
 code_input = 4'b0000;
 final_key_input = 4'b0000;
 // Apply reset for some cycles
 #20;
 rst = 0;
 // Phase 1: Keypad FSM
 keypad_input = 4'b0011;
 #20;
 keypad_input = 4'b1111; // done condition
 #20;
 // Phase 2: Direction FSM
 direction_input = 3'b010;
 #20;
 direction_input = 3'b111; // done condition
 #20;
 // Phase 3: Color FSM
 color_input = 4'b0010;
 #20;
 color_input = 4'b1111; // done condition
 #20;
 // Phase 4: Pattern FSM
 pattern_input = 8'h55;
 #20;
 pattern_input = 8'hFF; // done condition
 #20;
 // Phase 5: Final Key FSM
 code_input = 4'b1010;
 final_key_input = 4'b0101;
 #20;
 code_input = 4'b1111;
 final_key_input = 4'b1111; // done condition
 #20;
 #50;
 $finish;
 end
 initial begin
 $monitor("Time=%0t | vault_escape=%b | all_done=%b", $time, vault_escape, all_done);
 end
endmodule
