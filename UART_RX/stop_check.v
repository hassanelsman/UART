// combinantiol clock
module stop_check (
input wire          sampled_bit,
input wire          smpl_ready,
input wire          stp_chk_en,
output reg          stp_err
);

always @(*) begin
    if (stp_chk_en && !sampled_bit && smpl_ready) begin
        stp_err = 1'b1;
    end else begin
        stp_err = 1'b0 ; 
    end
end
endmodule