///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////      UART_TX Module      /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

module UART_TX #(parameter DATA_WIDTH = 8)(
    input   wire    [DATA_WIDTH-1:0]    P_DATA,
    input   wire                        DATA_VALID,
    input   wire                        PAR_EN,
    input   wire                        PAR_TYP,
    input   wire                        CLK,
    input   wire                        RST,
    output  wire                        TX_OUT,
    output  wire                        Busy
);

// Internal signals declartions
wire            ser_done_uart;
wire            ser_en_uart;
wire            ser_data_uart;
wire    [1:0]   mux_sel_uart;
wire            par_bit_uart;

// Modules Instantiation
Parity_Calc #(.DATA_WIDTH(DATA_WIDTH)) 
Parity_Unit (
    .Parity_Calc_RST(RST),
    .P_DATA(P_DATA),
    .Data_Valid(DATA_VALID),
    .PAR_TYP(PAR_TYP),
    .par_bit(par_bit_uart)
);

serializer #(.DATA_WIDTH(DATA_WIDTH)) 
Ser_Unit (
    .SER_CLK(CLK),
    .SER_RST(RST),
    .P_DATA(P_DATA),
    .ser_en(ser_en_uart),
    .ser_done(ser_done_uart),
    .ser_data(ser_data_uart)
);

FSM FSM_Unit(
    .FSM_CLK(CLK),
    .FSM_RST(RST),
    .Data_Valid(DATA_VALID),
    .PAR_EN(PAR_EN),
    .ser_done(ser_done_uart),
    .ser_en(ser_en_uart),
    .mux_sel(mux_sel_uart),
    .busy(Busy)
);

MUX MUX_Unit(
    .mux_sel(mux_sel_uart),
    .ser_data(ser_data_uart),
    .par_bit(par_bit_uart),
    .TX_OUT(TX_OUT)
);



endmodule