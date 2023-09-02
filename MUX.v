module MUX (
    input   wire    [1:0]   mux_sel,
    input   wire            ser_data,
    input   wire            par_bit,
    output  reg             TX_OUT
);
    
always @(*)
begin
    case (mux_sel)
    2'b00   :   TX_OUT = 1'b0;      //start bit = 0
    2'b01   :   TX_OUT = 1'b1;      //stop bit  = 1
    2'b10   :   TX_OUT = ser_data; 
    2'b11   :   TX_OUT = par_bit; 
    default :   TX_OUT = 1'b1;
    
    endcase
end


endmodule