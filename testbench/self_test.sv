// Prints out the alphabet, then sets done

module cpu(
    input logic clk,
    input logic rst,
    output logic done,
    output logic [63:0] mem_raddr,
    input logic [63:0] mem_rdata,
    output logic mem_wen,
    output logic [63:0] mem_waddr,
    output logic [63:0] mem_wdata
);

    logic [63:0] char_to_write;
    assign mem_wdata = char_to_write;
    assign mem_waddr = 64'hffffffffffffffff;
    always @(posedge clk) begin
        if (rst) begin
            char_to_write <= 64'h40;
            mem_wen <= 0;
        end else begin
            char_to_write <= char_to_write + 1;
            mem_wen <= 1;
        end
        if (char_to_write > 64'h58) begin
            done <= 1;
        end
    end
endmodule
