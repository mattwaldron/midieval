module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output reg [7:0] led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    input midi_signal
  );
 
  wire rst = ~rst_n; // make reset active high
   
  avr_interface avr_interface (
    .clk(clk),
    .rst(rst),
    .cclk(cclk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_ss(spi_ss),
    .spi_channel(spi_channel),
    .tx(avr_rx), // FPGA tx goes to AVR rx
    .rx(avr_tx),
    .channel(4'd15), // invalid channel disables the ADC
    .new_sample(),
    .sample(),
    .sample_channel(),
    .tx_data(midi_byte_from_detector),
    .new_tx_data(midi_byte_ready),
    .tx_busy(tx_busy),
    .tx_block(avr_rx_busy),
    .rx_data(rx_data),
    .new_rx_data(new_rx_data)
  );
 
// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

midi_byte_detect midi_detect (
    .clk(clk), // 50MHz clock
    .rst(rst),
    .midi_signal(midi_signal),
    .midi_byte_out(midi_byte_from_detector),
    .byte_ready(midi_byte_ready)
);

always @(posedge midi_byte_ready) begin
  led <= led + 1;
end

endmodule