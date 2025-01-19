// a 1-bit full adder
module full_adder(a, b, cin, s, cout);
// inputs and outputs
input   a, b, cin;
output s,cout;
wire p,g;
assign p=a^b;
assign g=a&b;
assign s=p^cin;
assign cout=g|(p&cin);

endmodule
module mul_4bits(x, y, out);
// inputs and outputs
input   [3:0] x, y;
output  [7:0] out;
wire a1,a2,a3,a4,b1,b2,b3,b4,c1,c2,c3,c4,d1,d2,d3,d4;
wire o2,o3,o4,o6,o7,o8,o10,o11,o12;
wire r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
assign a1=x[0]&y[0];
assign a2=x[1]&y[0];
assign a3=x[2]&y[0];
assign a4=x[3]&y[0];
assign b1=x[0]&y[1];
assign b2=x[1]&y[1];
assign b3=x[2]&y[1];
assign b4=x[3]&y[1];
assign c1=x[0]&y[2];
assign c2=x[1]&y[2];
assign c3=x[2]&y[2];
assign c4=x[3]&y[2];
assign d1=x[0]&y[3];
assign d2=x[1]&y[3];
assign d3=x[2]&y[3];
assign d4=x[3]&y[3];

full_adder FA1(.a(a1),.b(1'b0),.cin(1'b0),.s(out[0]),.cout(r1));
full_adder FA2(.a(a2),.b(1'b0),.cin(r1),.s(o2),.cout(r2));
full_adder FA3(.a(a3),.b(1'b0),.cin(r2),.s(o3),.cout(r3));
full_adder FA4(.a(a4),.b(1'b0),.cin(r3),.s(o4),.cout(r4));
full_adder FA5(.a(b1),.b(o2),.cin(1'b0),.s(out[1]),.cout(r5));
full_adder FA6(.a(b2),.b(o3),.cin(r5),.s(o6),.cout(r6));
full_adder FA7(.a(b3),.b(o4),.cin(r6),.s(o7),.cout(r7));
full_adder FA8(.a(b4),.b(r4),.cin(r7),.s(o8),.cout(r8));
full_adder FA9(.a(c1),.b(o6),.cin(1'b0),.s(out[2]),.cout(r9));
full_adder FA10(.a(c2),.b(o7),.cin(r9),.s(o10),.cout(r10));
full_adder FA11(.a(c3),.b(o8),.cin(r10),.s(o11),.cout(r11));
full_adder FA12(.a(c4),.b(r8),.cin(r11),.s(o12),.cout(r12));
full_adder FA13(.a(d1),.b(o10),.cin(1'b0),.s(out[3]),.cout(r13));
full_adder FA14(.a(d2),.b(o11),.cin(r13),.s(out[4]),.cout(r14));
full_adder FA15(.a(d3),.b(o12),.cin(r14),.s(out[5]),.cout(r15));
full_adder FA16(.a(d4),.b(r12),.cin(r15),.s(out[6]),.cout(out[7]));
endmodule


module PE(
    clk ,
    active ,
    data_in ,
    w_in ,
    sum_in ,
    weight_wren ,
    mac_out ,
    data_out ,
    weight_out ,
    weight_wren_out ,
    active_out
        );
        
input clk;
input active ; //a signal that indicates whether the systolic array should be actively performing multiplies and passing values .
input  [3:0] data_in ; // an 8 - bit input representing a matrix element that is multiplied by the weight .
input  [3:0] w_in ; // an 8 - bit input representing the weight value .
input  [7:0] sum_in ; //a 16 - bit input representing the sum input from the previous element in the systolic array .
input weight_wren ; //a control signal that determines whether the internal weight should be updated .
output reg  [7:0] mac_out ; //a 16 - bit output representing the result of the multiply -and - accumulate operation ( datain * weight + sumin ).
output reg  [3:0] data_out ; // an 8 -bit output that passes the datain value to the right , to the next processing element in the systolic array .
output reg  [3:0] weight_out ; // an 8 -bit output representing the weight value that is passed to the right , to the next processing element in the systolic array .
output reg weight_wren_out ; //a control signal that determines whether the next processing element should update its internal weight .
output reg active_out ; //a signal indicating whether the systolic array should be actively performing multiplies and passing values .


// internal signals

wire [7:0] product ;


mul_4bits mult1 ( .x( data_in ) , .y( w_in ) , . out ( product ));

always@ (posedge clk)
begin

if( active == 1'b1)
begin
// Update the values
data_out <= data_in ;
mac_out <= sum_in + product ;
active_out <= active;
end
else
begin
// Stall
data_out <= data_out ;
mac_out <= mac_out ;
active_out <= active_out;
end
end

always@ (posedge clk)
begin

if (( weight_wren == 1'b1) )
begin
// Initialize w_in value
weight_out <= w_in ;
weight_wren_out <= weight_wren;
end
else
// Hold old weight data
weight_out <= weight_out ;
weight_wren_out <= weight_wren_out;
end
endmodule


module SysArray (
    clk ,
    active ,
    data_in ,
    w_in ,
    sum_in ,
    weight_wren ,
    mac_out ,
    w_out ,
    weight_wren_out ,
    active_out ,
    data_out
                );

parameter row_width = 4;                                 // matrix dimentions
localparam data_width = 4* row_width ; 
localparam weight_width = 4 * row_width ;                // Each PE in the row needs 8 bits to represent the input weight
localparam sum_width = 8 * row_width ;                   // Each PE needs 16 bits to represent the input sum fields
input clk;
input  active  ;
input  [ data_width -1:0]  data_in  ;                    // Each row needs 8 bit input data
input  [ weight_width -1:0] w_in;                        //8 bits for each PE. Left most PE has LSB
input  [ sum_width -1:0] sum_in ;                        // 16 bits for each PE. Left most PE has LSB
input [row_width -1 :0] weight_wren  ;
output  [ sum_width -1:0] mac_out ;
output  [ weight_width -1:0] w_out ;
output [row_width -1 :0] weight_wren_out ;
output [row_width -1 :0] active_out ;
output  [data_width -1:0] data_out ;                     // Outputs to the right side of the array
// Intraconnections within the sysrow (PE -> PE)
wire  active_temp [row_width-1 :0][row_width-1:0] ;
wire  weight_wren_temp [row_width-1:0][row_width-1:0] ;
wire  [3 : 0] data_temp [row_width-1:0][row_width-1:0];
wire  [3 : 0] w_temp [row_width-1:0][row_width-1:0];
wire  [7: 0] mac_temp [row_width-1:0][row_width-1:0];


genvar i,j;
generate // generate 2D array of the mac block that is pramatrized to multiply NxN matrix
    for (j=0; j<row_width; j = j + 1) 
    begin
        if(j == 0)
        begin
            for (i = 0 ; i < row_width ; i = i + 1)
            begin : generate_PE
                if(i == 0)
                begin
                PE first_pe (
                .clk(clk) ,
                . active ( active ) ,
                . data_in ( data_in [3:0] ) ,
                . w_in ( w_in [3:0]) ,
                . sum_in ( sum_in [7:0]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_temp [j][i]) ,
                . data_out ( data_temp [j][i]) ,
                . weight_out ( w_temp [j][i]) ,
                . weight_wren_out ( weight_wren_temp [j][i]) ,
                . active_out ( active_temp [j][i])
                );
                end
                else if(i == row_width - 1)
                begin
                PE last_pe_in_first_row (
                .clk(clk) ,
                . active ( active_temp [j][i - 1]) ,
                . data_in ( data_temp [j][i-1]) ,
                . w_in ( w_in [((i +1)*4) -1:( i*4)]) ,
                . sum_in ( sum_in [((i +1)*8) -1:( i *8)]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_temp [j][i]) ,
                . data_out ( data_out [((j +1)*4) -1:( j*4)]) ,
                . weight_out ( w_temp [j][i]) ,
                . weight_wren_out ( weight_wren_temp [j][i]) ,
                . active_out ( active_out [j])
                );
                end
                else begin
                PE normal_pe_in_first_row (
                .clk(clk) ,
                . active ( active_temp [j][i - 1]) ,
                . data_in ( data_temp [j][i-1]) ,
                . w_in ( w_in [((i +1)*4) -1:( i*4)]) ,
                . sum_in ( sum_in [((i +1)*8) -1:( i *8)]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_temp [j][i]) ,
                . data_out ( data_temp [j][i]) ,
                . weight_out ( w_temp [j][i]) ,
                . weight_wren_out ( weight_wren_temp [j][i]) ,
                . active_out ( active_temp [j][i])
                );

                end
            end
        end
        else if(j == row_width - 1)
        begin
            for (i = 0 ; i < row_width ; i = i + 1)
            begin : generate_PE
                if(i == 0)
                begin
                PE first_pe_in_last_row (
                .clk(clk) ,
                . active ( active_temp [j-1][i]) ,
                . data_in ( data_in [((j +1)*4) -1:( j*4)] ) ,
                . w_in ( w_temp  [j-1][i]) ,
                . sum_in ( mac_temp [j-1][i]) ,
                . weight_wren (weight_wren [i]) ,
                . mac_out ( mac_out [7:0]) ,
                . data_out ( data_temp [j][i]) ,
                . weight_out ( w_out [3:0]) ,
                . weight_wren_out ( weight_wren_out [i]) ,
                . active_out ( active_temp [j][i])
                );
                end
                else if(i == row_width - 1)
                begin
                PE last_pe_in_last_row (
                .clk(clk) ,
                . active ( active_temp [j][i - 1]) ,
                . data_in ( data_temp [j][i-1]) ,
                . w_in ( w_temp [j-1][i]) ,
                . sum_in ( mac_temp [j-1] [i]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_out [((i +1)*8) -1:( i *8)]) ,
                . data_out ( data_out [((j +1)*4) -1:( j*4)]) ,
                . weight_out ( w_out [((i +1)*4) -1:( i*4)]) ,
                . weight_wren_out ( weight_wren_out [i]) ,
                . active_out ( active_out [j])
                );
                end
                else begin
                PE normal_pe__in_last_row (
                .clk(clk) ,
                . active ( active_temp [j][i - 1]) ,
                . data_in ( data_temp [j][i-1]) ,
                . w_in ( w_temp [j-1][i]) ,
                . sum_in ( mac_temp [j-1][i]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_out [((i +1)*8) -1:( i *8)]) ,
                . data_out ( data_temp [j][i]) ,
                . weight_out ( w_out [((i +1)*4) -1:( i*4)]) ,
                . weight_wren_out ( weight_wren_out [i]) ,
                . active_out ( active_temp [j][i])
                );

                end
            end
        end

        else 
        begin
            for (i = 0 ; i < row_width ; i = i + 1)
            begin : generate_PE
                if(i == 0)
                begin
                PE first_pe_in_inner_row (
                .clk(clk) ,
                . active ( active_temp [j-1][i]) ,
                . data_in ( data_in [((j +1)*4) -1:( j*4)] ) ,
                . w_in ( w_temp  [j-1][i]) ,
                . sum_in ( mac_temp [j-1][i]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_temp [j][i]) ,
                . data_out ( data_temp [j][i]) ,
                . weight_out ( w_temp [j][i]) ,
                . weight_wren_out ( weight_wren_temp [j][i]) ,
                . active_out ( active_temp [j][i])
                );
                end
                else if(i == row_width - 1)
                begin
                PE last_pe_in_inner_row (
                .clk(clk) ,
                . active ( active_temp [j][i - 1]) ,
                . data_in ( data_temp [j][i-1]) ,
                . w_in ( w_temp [j-1][i]) ,
                . sum_in ( mac_temp [j-1][i]) ,
                . weight_wren ( weight_wren [i]) ,
                . mac_out ( mac_temp [j][i]) ,
                . data_out ( data_out [((j +1)*4) -1:( j*4)]) ,
                . weight_out ( w_temp [j][i]) ,
                . weight_wren_out ( weight_wren_temp[j][i]) ,
                . active_out ( active_out [j])
                );
                end
                else begin
                PE normal_pe_in_inner_row (
                .clk(clk) ,
                . active ( active_temp [j][i - 1]) ,
                . data_in ( data_temp [j][i-1]) ,
                . w_in ( w_temp [j-1][i]) ,
                . sum_in ( mac_temp [j-1][i]) ,
                . weight_wren (weight_wren [i]) ,
                . mac_out ( mac_temp [j][i]) ,
                . data_out ( data_temp [j][i]) ,
                . weight_out ( w_temp [j][i]) ,
                . weight_wren_out ( weight_wren_temp [j][i]) ,
                . active_out ( active_temp [j][i])
                );

                end
            end
        end

    end
endgenerate
endmodule
