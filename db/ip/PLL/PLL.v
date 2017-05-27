// PLL.v

// Generated using ACDS version 13.0sp1 232 at 2017.05.27.21:53:10

`timescale 1 ps / 1 ps
module PLL (
		input  wire  clock_27_clk,    //    clock_27.clk
		output wire  pixel_clock_clk, // pixel_clock.clk
		input  wire  reset_reset      //       reset.reset
	);

	PLL_PLL pll (
		.clk       (clock_27_clk),    //       inclk_interface.clk
		.reset     (reset_reset),     // inclk_interface_reset.reset
		.read      (),                //             pll_slave.read
		.write     (),                //                      .write
		.address   (),                //                      .address
		.readdata  (),                //                      .readdata
		.writedata (),                //                      .writedata
		.c0        (pixel_clock_clk), //                    c0.clk
		.areset    (),                //        areset_conduit.export
		.locked    (),                //        locked_conduit.export
		.phasedone ()                 //     phasedone_conduit.export
	);

endmodule