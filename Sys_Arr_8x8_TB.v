/* ----------------------------------------------------------------------------------------------- //
Project Title: Systoric Array 8 x 8 Testbench
Institution: University of Science and Technology, Zewail City
Name: Mahmoud Marzouk
File Description: Sys_Arr_8x8_TB
Date: 4/5/2024
// ----------------------------------------------------------------------------------------------- */
module Sys_Arr_8x8_TB ();
parameter width_height = 8;
localparam weight_width = 4 * width_height ;
localparam sum_width = 8 * width_height ;
localparam data_width = 4 * width_height ;
// inputs to DUT
reg clk;
reg active ;
reg [ data_width -1:0] data_in ;
reg [ weight_width -1:0] w_in;
reg [ sum_width -1:0] sum_in ;
reg [ width_height -1:0] weight_wren ;
// outputs from DUT
wire [ sum_width -1:0] mac_out ;
wire [ weight_width -1:0] w_out ;
wire [ width_height -1:0] weight_wren_out ;
wire [ width_height -1:0] active_out ;
wire [ data_width -1:0] data_out ;
wire  [7 : 0] col1 ;
wire  [7 : 0] col2 ;
wire  [7 : 0] col3 ;
wire  [7 : 0] col4 ;
wire  [7 : 0] col5 ;
wire  [7 : 0] col6 ;
wire  [7 : 0] col7 ;
wire  [7 : 0] col8 ;

SysArray DUT(
.clk(clk) ,
. active ( active ) ,
. data_in ( data_in ) ,
. w_in (w_in) ,
. sum_in ( sum_in ) ,
. weight_wren ( weight_wren ) ,
. mac_out ( mac_out ) ,
. w_out ( w_out ) ,
. weight_wren_out ( weight_wren_out ) ,
. active_out ( active_out ) ,
. data_out ( data_out )
);
defparam DUT.row_width = width_height ;
assign { col8 , col7 , col6 , col5 ,col4 , col3 , col2 , col1 } = mac_out ;
always@ (*)
begin
#5;
clk <= ~ clk;
end
initial begin
clk = 1 'b0;
active = 0;
data_in = 32 'h0000_0000 ;
w_in = 32 'h0000_0000 ;
sum_in = 64 'h0000_0000_0000_0000 ;
weight_wren = 8 'b00000000 ;
#10;
weight_wren = 8 'b11111111 ;
w_in = {4'd7 , 4'd8 , 4'd5 , 4'd6, 4'd5 , 4'd5 , 4'd4 , 4'd2};
#10;
w_in = {4'd3 , 4'd1 , 4'd9 , 4'd1, 4'd2 , 4'd2 , 4'd2 , 4'd8};
#10;
w_in = {4'd2 , 4'd5 , 4'd7 , 4'd2, 4'd6 , 4'd3 , 4'd7 , 4'd6};
#10;
w_in = {4'd6 , 4'd3 , 4'd5 , 4'd6, 4'd8 , 4'd2 , 4'd2 , 4'd4};
#10;
w_in = {4'd8 , 4'd4 , 4'd9 , 4'd5, 4'd9 , 4'd7 , 4'd3 , 4'd7};
#10;
w_in = {4'd4 , 4'd1 , 4'd6 , 4'd8, 4'd5 , 4'd3 , 4'd5 , 4'd3};
#10;
w_in = {4'd5 , 4'd5 , 4'd3 , 4'd9, 4'd3 , 4'd5 , 4'd9 , 4'd5};
#10;
w_in = {4'd1 , 4'd7 , 4'd2 , 4'd3, 4'd7 , 4'd3 , 4'd8 , 4'd1};
weight_wren = 8'b00000000 ;
#10;
active = 1'b1;
data_in = {4'd0 , 4'd0 , 4'd0 , 4'd0, 4'd0 , 4'd0 , 4'd0 , 4'd1};
#10;
data_in = {4'd0 , 4'd0 , 4'd0 , 4'd0, 4'd0 , 4'd0 , 4'd4 , 4'd4};
#10;
data_in = {4'd0 , 4'd0 , 4'd0 , 4'd0, 4'd0 , 4'd3 , 4'd7 , 4'd5};
#10;
data_in = {4'd0 , 4'd0 , 4'd0 , 4'd0, 4'd5 , 4'd6 , 4'd1 , 4'd2};
#10
data_in = {4'd0 , 4'd0 , 4'd0 , 4'd3, 4'd1 , 4'd4 , 4'd3 , 4'd7};
#10;
data_in = {4'd0 , 4'd0 , 4'd1 , 4'd7, 4'd5 , 4'd7 , 4'd6 , 4'd4};
#10;
data_in = {4'd0 , 4'd7 , 4'd4 , 4'd9, 4'd1 , 4'd3 , 4'd2 , 4'd2};
#10;
data_in = {4'd5 , 4'd5 , 4'd3 , 4'd6, 4'd2 , 4'd8 , 4'd4 , 4'd2};
#10;
data_in = {4'd3 , 4'd8 , 4'd4 , 4'd2, 4'd7 , 4'd1 , 4'd2 , 4'd0};
active = 1'b0;
#10;
data_in = {4'd1 , 4'd1 , 4'd6 , 4'd5, 4'd1 , 4'd5 , 4'd0 , 4'd0};
#10;
data_in = {4'd6 , 4'd5 , 4'd8 , 4'd3, 4'd6 , 4'd0 , 4'd0 , 4'd0};
#10;
data_in = {4'd7 , 4'd6 , 4'd7 , 4'd4, 4'd0 , 4'd0 , 4'd0 , 4'd0};
#10;
data_in = {4'd4 , 4'd8 , 4'd9 , 4'd0, 4'd0 , 4'd0 , 4'd0 , 4'd0};
#10;
data_in = {4'd5 , 4'd3 , 4'd0 , 4'd0, 4'd0 , 4'd0 , 4'd0 , 4'd0};
#10;
data_in = {4'd8 , 4'd0 , 4'd0 , 4'd0, 4'd0 , 4'd0 , 4'd0 , 4'd0};
#10;
data_in = 0;
#50;

end
endmodule