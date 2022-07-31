//module name & ports declaration
module parity_clc (
input wire         clk,
input wire         par_typ,
input wire         data_valid,
input wire [7:0]   p_data,
output reg         parity_bit
);
wire               par_bit ;
//RTL Code
always @(posedge clk)
begin
    if (data_valid) 
    begin
     //parity_bit <= ^par_bit ;
      if (par_typ)
          parity_bit <= ~par_bit; // logical error duo to blocking assig. in seq. always block !
       else 
          parity_bit <= par_bit ;
    end
end
assign par_bit = ^p_data ;
endmodule