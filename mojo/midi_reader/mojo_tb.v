`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:29:15 12/18/2019
// Design Name:   mojo_top
// Module Name:   C:/Users/waldr/Documents/mojo-base-project-master/mojo_tb.v
// Project Name:  Mojo-Base
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mojo_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mojo_tb;

	// Inputs
	reg clk;
	reg rst_n;
	reg cclk;
	reg spi_ss;
	reg spi_mosi;
	reg spi_sck;
	reg avr_tx;
	reg avr_rx_busy;
	reg midi_signal;

	// Outputs
	wire [7:0] led;
	wire spi_miso;
	wire [3:0] spi_channel;
	wire avr_rx;

	// Instantiate the Unit Under Test (UUT)
	mojo_top uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.cclk(cclk), 
		.led(led), 
		.spi_miso(spi_miso), 
		.spi_ss(spi_ss), 
		.spi_mosi(spi_mosi), 
		.spi_sck(spi_sck), 
		.spi_channel(spi_channel), 
		.avr_tx(avr_tx), 
		.avr_rx(avr_rx), 
		.avr_rx_busy(avr_rx_busy), 
		.midi_signal(midi_signal)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		cclk = 0;
		clk = 0;
		spi_ss = 0;
		spi_mosi = 0;
		spi_sck = 0;
		avr_tx = 0;
		avr_rx_busy = 0;
		midi_signal = 1;
		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1;
		// Add stimulus here
	end
	
	initial begin
	  forever #10 clk = ~clk;
   end
	
	initial begin
	  #200;
	  forever #32000 midi_signal = ~midi_signal;
   end
	  
      
endmodule

