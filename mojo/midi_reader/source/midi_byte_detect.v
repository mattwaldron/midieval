`define STATE_IDLE 0
`define STATE_RECEIVING 1
`define STATE_RECEIVED 2

module midi_byte_detect(
    input clk, // 50MHz clock
    input rst,
    input midi_signal,
    output reg [7:0] midi_byte_out,
    output reg byte_ready
  );
 
  // midi clk width = 320 us, which is 16000 ticks of the 50MHz clock;  we'll count 8000 
  // ticks and sample every posedge, so that we catch the midi_signal in the middle of the pulse
  reg [12:0] counter;
  reg [7:0] midi_fifo;

  reg midi_clk;
  
  reg [1:0] state;
  reg [3:0] bit_num;
   
  always @(posedge clk) begin
    if (rst) begin
      state <= `STATE_IDLE;
      counter <= 0;
      midi_clk <= 0;
    end else begin
      if (state == `STATE_RECEIVING || state == `STATE_RECEIVED) begin
        if (counter == 8000) begin
          midi_clk <= ~midi_clk;
          counter <= 0;
        end else begin
          counter <= counter + 1;
        end
      end else if( state == `STATE_IDLE) begin
        if (midi_signal == 0) begin
          counter <= 0;
          state <= `STATE_RECEIVING;
          bit_num <= 0;
        end
      end
    end
  end
  
  always @(midi_clk) begin
    if (midi_clk == 1) begin  // posedge midi_clk
      if (bit_num == 9) begin
        byte_ready <= 0;
        state <= `STATE_IDLE;
      end else begin
        midi_fifo[7:1] <= midi_fifo[6:0];
        midi_fifo[0] <= midi_signal;
        bit_num <= bit_num + 1;
      end
    end else begin  // negedge midi_clk
      if (bit_num == 9) begin
        midi_byte_out <= midi_fifo;
        byte_ready <= 1;
        state <= `STATE_RECEIVED;
      end
    end
  end
 
endmodule
