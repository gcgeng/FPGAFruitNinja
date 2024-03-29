`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 20:16:55
// Design Name: 
// Module Name: vga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:57:24 12/22/2020 
// Design Name: 
// Module Name:    VGA 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGA(
    input clk,
    input [11:0] Din,
    output reg [9:0] row,
    output reg [9:0] col,
    output reg rdn,
    output reg [3:0] R, G, B,
    output reg HS, VS 
    );
    
    reg [9:0] h_count = 0;

    always @ (posedge clk) begin
        if (h_count == 10'd799)
            h_count <= 10'h0;
        else h_count <= h_count + 10'h1;
    end

    reg [9:0] v_count = 0;

    always @ (posedge clk) begin
        if (h_count == 10'd799) begin
            if(v_count == 10'd524) v_count <= 10'h0;
            else v_count <= v_count + 10'h1;
        end
    end

    wire [9:0] row_addr = v_count - 10'd35;
    wire [9:0] col_addr = h_count - 10'd143;
    wire       h_sync   = (h_count > 10'd95);
    wire       v_sync   = (v_count > 10'd1);
    wire       read     = (h_count > 10'd142) &&
                          (h_count < 10'd783) &&
                          (v_count > 10'd34) &&
                          (v_count < 10'd515);

    always @ (posedge clk) begin
        row <= row_addr;
        col <= col_addr;
        rdn <= ~read;
        HS  <= h_sync;
        VS  <= v_sync;
        R   <= rdn ? 4'h0 : Din[3:0];
        G   <= rdn ? 4'h0 : Din[7:4];
        B   <= rdn ? 4'h0 : Din[11:8];
    end

endmodule

