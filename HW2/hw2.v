module ALU(
    clk,
    rst_n,
    valid,
    ready,
    mode,
    in_A,
    in_B,
    out
);

    // Definition of ports
    input         clk, rst_n;
    input         valid;
    input  [1:0]  mode; // mode: 0: mulu, 1: divu, 2: and, 3: or
    output        ready;
    input  [31:0] in_A, in_B;
    output [63:0] out;

    // Definition of states
    parameter IDLE = 3'd0;
    parameter MUL  = 3'd1;
    parameter DIV  = 3'd2;
    parameter AND = 3'd3;
    parameter OR = 3'd4;
    parameter OUT  = 3'd5;

    // Todo: Wire and reg if needed
    reg  [ 2:0] state, state_nxt;
    reg  [ 4:0] counter, counter_nxt;
    reg  [63:0] shreg, shreg_nxt;
    reg  [31:0] alu_in, alu_in_nxt;
    reg  [32:0] alu_out;
    reg         ready;
    ////reg  [31:0] temp, temp_nxt;

    // Todo: Instatiate any primitives if needed

    // Todo 5: Wire assignments
    assign out = shreg;
    // Combinational always block

    always @(*) begin
        if(state==OUT) ready = 1;
        else ready = 0;
    end

    // Todo 1: Next-state logic of state machine
    always @(*) begin
        case(state)
            IDLE: begin
                if(!valid)                state_nxt = IDLE;
                else if(valid && mode==0) state_nxt = MUL;
                else if(valid && mode==1) state_nxt = DIV;
                else if(valid && mode==2) state_nxt = AND;
                else                      state_nxt = OR;
            end
            MUL : state_nxt = (counter==31) ? OUT : MUL;
            DIV : state_nxt = (counter==31) ? OUT : DIV;
            AND : state_nxt = OUT;
            OR  : state_nxt = OUT;
            OUT : state_nxt = IDLE;
            default : state_nxt = IDLE;
        endcase
    end
    // Todo 2: Counter
    always @(*) begin
        if(state==MUL && counter<31) begin
            counter_nxt = counter + 1;
        end
        else if(state==DIV && counter<31) begin
            counter_nxt = counter + 1;
        end
        else begin
            counter_nxt = 0;
        end
    end

    // ALU input
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) begin
                    alu_in_nxt = in_B;
                    ////temp_nxt = in_A;
                    //shreg_nxt[31:0] = in_A;
                    //shreg_nxt[63:32] = 32'b0;
                end
                else begin
                    alu_in_nxt = 0;
                    ////temp_nxt = 0;
                    //shreg_nxt[31:0] = 0;
                    //shreg_nxt[63:32] = 32'b0;
                end
            end
            OUT : begin
                alu_in_nxt = 0;
                ////temp_nxt = 0;
                //shreg_nxt = 0;
            end
            default: begin
                alu_in_nxt = alu_in;
                ////temp_nxt = temp;
                //shreg_nxt = shreg;
            end
        endcase
    end

    // Todo 3: ALU output
    always @(*) begin
        case(state)
            IDLE: alu_out = 0;
            MUL : begin
                if(shreg[0]==1)
                    alu_out = alu_in + shreg[63:32];
                else
                    alu_out = shreg[63:32];
            end
            DIV : begin
                if(shreg[62:31]>=alu_in) begin
                    alu_out = shreg[62:31] - alu_in;
                end
                else begin 
                    alu_out = shreg[62:31];
                end
            end
            AND : alu_out = shreg[31:0] & alu_in;
            OR  : alu_out = shreg[31:0] | alu_in;
            OUT : alu_out = 0;
            default : alu_out = 0;
        endcase
    end

    // Todo 4: Shift register
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) begin
                    //shreg_nxt = {32'b0, in_A};
                    //shreg_nxt[32:0] = alu_out;
                    shreg_nxt[31:0] = in_A;
                    shreg_nxt[63:32] = 32'b0;
                end
                else begin
                    //shreg_nxt = 0;
                    //shreg_nxt[32:0] = alu_out;
                    shreg_nxt[31:0] = 0;
                    shreg_nxt[63:32] = 32'b0;
                end
            end
            MUL : begin
                //shreg_nxt = shreg >> 1;
                //shreg_nxt[63:31] = alu_out;
                shreg_nxt = {alu_out, shreg[31:1]};
            end
            DIV : begin
                shreg_nxt = {alu_out[31:0], shreg[30:0], (shreg[62:31]>=alu_in)};
            end
            AND : shreg_nxt = {31'b0, alu_out};
            OR  : shreg_nxt = {31'b0, alu_out};
            OUT : //shreg_nxt = 0;
            shreg_nxt = shreg;
            default : //shreg_nxt = 0;
            shreg_nxt = shreg;
        endcase
    end
    // Todo: Sequential always block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            counter <= 0;
            shreg <= 0;
            alu_in <= 0;
        end
        else begin
            state <= state_nxt;
            counter <= counter_nxt;
            shreg <= shreg_nxt;
            alu_in <= alu_in_nxt;
            ////temp <= temp_nxt;
        end
    end

endmodule