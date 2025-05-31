DESIGN PART
module top_module (
 input wire clk,
 input wire rst,
 input wire [3:0] keypad_input,
 input wire [2:0] direction_input,
 input wire [3:0] color_input,
 input wire [7:0] pattern_input,
 input wire [3:0] code_input,
 input wire [3:0] final_key_input,
 output wire vault_escape,
 output wire all_done
);
// Phase done signals
wire phase1_done, phase2_done, phase3_done, phase4_done, phase5_done;
// Unlock signals (optional, for debug or control)
wire p1_unlock, p2_unlock, p3_unlock, p4_unlock, p5_unlock;
// Phase 1: Keypad FSM
phase1_keypad key_fsm (
 .clk(clk),
 .rst(rst),
 .keypad_input(keypad_input),
 .phase_done(phase1_done),
 .unlock(p1_unlock)
);
// Phase 2: Direction FSM
phase2_direction dir_fsm (
 .clk(clk),
 .rst(rst),
 .start(phase1_done),
 .direction_input(direction_input),
 .phase_done(phase2_done),
 .unlock(p2_unlock)
);
// Phase 3: Color FSM
phase3_color color_fsm (
 .clk(clk),
 .rst(rst),
 .start(phase2_done),
 .color_input(color_input),
 .phase_done(phase3_done),
 .unlock(p3_unlock)
);
// Phase 4: Pattern FSM
phase4_pattern pattern_fsm (
 .clk(clk),
 .rst(rst),
 .start(phase3_done),
 .pattern_input(pattern_input),
 .phase_done(phase4_done),
 .unlock(p4_unlock)
);
// Phase 5: Final Key FSM
phase5_finalkey finalkey_fsm (
 .clk(clk),
 .rst(rst),
 .start(phase4_done),
 .code_input(code_input),
 .final_key_input(final_key_input),
 .phase_done(phase5_done),
 .unlock(p5_unlock)
);
// vault_escape = last phase done
assign vault_escape = phase5_done;
// all_done = all phases done
assign all_done = phase1_done & phase2_done & phase3_done & phase4_done & phase5_done;
endmodule
module phase1_keypad (
 input wire clk,
 input wire rst,
 input wire [3:0] keypad_input,
 output reg phase_done,
 output reg unlock
);
 // State encoding using parameters
 parameter IDLE = 2'b00;
 parameter WAIT = 2'b01;
 parameter DONE = 2'b10;
 reg [1:0] state, next_state;
 always @(posedge clk or posedge rst) begin
 if (rst) state <= IDLE;
 else state <= next_state;
 end
 always @(*) begin
 next_state = state;
 phase_done = 0;
 unlock = 0;
 case(state)
 IDLE: begin
 if (keypad_input != 4'b0000)
 next_state = WAIT;
 end
 WAIT: begin
 // Simulate condition for done
 if (keypad_input == 4'b1111)
 next_state = DONE;
 end
 DONE: begin
 phase_done = 1;
 unlock = 1;
 // Stay here or reset
 end
 endcase
 end
endmodule
module phase2_direction (
 input wire clk,
 input wire rst,
 input wire start,
 input wire [2:0] direction_input,
 output reg phase_done,
 output reg unlock
);
 parameter IDLE = 2'b00;
 parameter WAIT = 2'b01;
 parameter DONE = 2'b10;
 reg [1:0] state, next_state;
 always @(posedge clk or posedge rst) begin
 if (rst) state <= IDLE;
 else if (~start) state <= IDLE;
 else state <= next_state;
 end
 always @(*) begin
 next_state = state;
 phase_done = 0;
 unlock = 0;
 case(state)
 IDLE: if (start) next_state = WAIT;
 WAIT: begin
 // Example: done if direction input == 3'b111
 if (direction_input == 3'b111) next_state = DONE;
 end
 DONE: begin
 phase_done = 1;
 unlock = 1;
 end
 endcase
 end
endmodule
module phase3_color (
 input wire clk,
 input wire rst,
 input wire start,
 input wire [3:0] color_input,
 output reg phase_done,
 output reg unlock
);
 parameter IDLE = 2'b00;
 parameter WAIT = 2'b01;
 parameter DONE = 2'b10;
 reg [1:0] state, next_state;
 always @(posedge clk or posedge rst) begin
 if (rst) state <= IDLE;
 else if (~start) state <= IDLE;
 else state <= next_state;
 end
 always @(*) begin
 next_state = state;
 phase_done = 0;
 unlock = 0;
 case(state)
 IDLE: if (start) next_state = WAIT;
 WAIT: begin
 if (color_input == 4'b1111) next_state = DONE;
 end
 DONE: begin
 phase_done = 1;
 unlock = 1;
 end
 endcase
 end
endmodule
module phase4_pattern (
 input wire clk,
 input wire rst,
 input wire start,
 input wire [7:0] pattern_input,
 output reg phase_done,
 output reg unlock
);
 parameter IDLE = 2'b00;
 parameter WAIT = 2'b01;
 parameter DONE = 2'b10;
 reg [1:0] state, next_state;
 always @(posedge clk or posedge rst) begin
 if (rst) state <= IDLE;
 else if (~start) state <= IDLE;
 else state <= next_state;
 end
 always @(*) begin
 next_state = state;
 phase_done = 0;
 unlock = 0;
 case(state)
 IDLE: if (start) next_state = WAIT;
 WAIT: begin
 if (pattern_input == 8'hFF) next_state = DONE;
 end
 DONE: begin
 phase_done = 1;
 unlock = 1;
 end
 endcase
 end
endmodule
module phase5_finalkey (
 input wire clk,
 input wire rst,
 input wire start,
 input wire [3:0] code_input,
 input wire [3:0] final_key_input,
 output reg phase_done,
 output reg unlock
);
 parameter IDLE = 2'b00;
 parameter WAIT = 2'b01;
 parameter DONE = 2'b10;
 reg [1:0] state, next_state;
 always @(posedge clk or posedge rst) begin
 if (rst) state <= IDLE;
 else if (~start) state <= IDLE;
 else state <= next_state;
 end
 always @(*) begin
 next_state = state;
 phase_done = 0;
 unlock = 0;
 case(state)
 IDLE: if (start) next_state = WAIT;
 WAIT: begin
 if ((code_input == 4'b1111) && (final_key_input == 4'b1111)) next_state = DONE;
 end
 DONE: begin
 phase_done = 1;
 unlock = 1;
 end
 endcase
 end
endmodule
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
