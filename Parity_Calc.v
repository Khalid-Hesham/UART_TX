module Parity_Calc  #(parameter DATA_WIDTH = 8) (
    input   wire                        Parity_Calc_CLK,
    input   wire                        Parity_Calc_RST,
    input   wire    [DATA_WIDTH-1:0]    P_DATA,
    input   wire                        PAR_TYP,
    input   wire                        Data_Valid,
    output  reg                         par_bit
);


always @(posedge Parity_Calc_CLK or negedge Parity_Calc_RST)
begin
        if(!Parity_Calc_RST)
            par_bit <= 'b0;
        else if(Data_Valid)
            begin
                if(PAR_TYP == 0) //Even parity bit
                    par_bit <= ^P_DATA;
                else if(PAR_TYP == 1) //Odd parity bit
                    par_bit <= ~^P_DATA;
            end
end



endmodule