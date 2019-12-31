`define STATE_IDLE 0
`define STATE_IN_START_BIT 1
`define STATE_RECEIVING 2
`define STATE_DONE 3

module midi_byte_detect(
    input clk, // 50MHz clock
    input rst,
    input midi_signal,
    output reg [7:0] midi_byte_out,
    output reg byte_ready
  );
 
  // midi clk width = 32 us, which is 1600 ticks of the 50MHz clock;  we'll count 800 
  // ticks and sample every posedge, so that we catch the midi_signal in the middle of the pulse
  localparam half_clock_ticks = 800;
  localparam full_clock_ticks = half_clock_ticks * 2;
  reg [15:0] counter;
  reg [7:0] midi_fifo;

  reg [1:0] state;
  reg [3:0] bit_num;
  
  // generate midi_clk and counter
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= `STATE_IDLE;
    end else begin
      if (state == `STATE_IDLE) begin
        if (midi_signal == 0) begin
          counter <= 0;
          bit_num <= 0;
          state <= `STATE_IN_START_BIT;
        end
      end else if(state == `STATE_IN_START_BIT) begin
        if (counter == half_clock_ticks) begin
          counter <= 0;
          state <= `STATE_RECEIVING;
        end else begin
          counter <= counter + 1;
        end
      end else if(state == `STATE_RECEIVING) begin
        if (counter == full_clock_ticks) begin
          counter <= 0;
          if (bit_num == 8) begin
            midi_byte_out <= midi_fifo;
            byte_ready <= 1;
            state <= `STATE_DONE;
          end else begin
            bit_num <= bit_num + 1;
            midi_fifo [7:1] <= midi_fifo[6:0];
            midi_fifo[0] <= midi_signal;
          end
        end else begin
          counter <= counter + 1;
        end
      end else if(state == `STATE_DONE) begin
        if (counter == half_clock_ticks) begin
          byte_ready <= 0;
          counter <= 0;
          state <= `STATE_IDLE;
        end else begin
          counter <= counter + 1;
        end
      end
    end
  end
  
 
endmodule
