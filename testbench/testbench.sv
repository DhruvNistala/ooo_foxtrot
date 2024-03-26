module main();


    logic clk;
    logic rst;
    logic done;

    logic [63:0]memory[0:2047];
    initial begin
        $readmemh("mem.hex",memory);
    end

    logic [63:0]mem_raddr;
    logic [63:0]mem_rdata;
    logic [63:0]mem_waddr;
    logic [63:0]mem_wdata;
    logic mem_wen;

    // Handle reads/writes to memory
    always @(posedge clk) begin
        mem_rdata <= memory[mem_raddr];
        if (mem_wen) begin
            memory[mem_waddr] <= mem_wdata;
        end
    end


    // No specification was given on the testbench<->cpu interface
    // This is just the most basic usable one
    cpu cpu_inst(
        .clk(clk),
        .rst(rst),
        .done(done),
        .mem_raddr(mem_raddr),
        .mem_rdata(mem_rdata),
        .mem_wen(mem_wen),
        .mem_waddr(mem_waddr),
        .mem_wdata(mem_wdata)
    );

    ////////////////////////////
    // Simulation only things //
    ////////////////////////////

    initial begin
        // dump to vcd
        $dumpfile("cpu.vcd");
        $dumpvars(0,main);

        // Reset
        #100;
        rst = 1;
        clk = 1;
        #100;
        rst = 0;
        clk = 0;
    end


    // Continue running the cpu
    always begin
        #500;
        clk = !clk;
    end

    always @(posedge clk) begin
        // Write chars from cpu
        if (mem_wen == 1 && mem_waddr == 64'hffffffffffffffff) begin
            $write("%c", mem_wdata[7:0]);
        end
        if (done == 1) begin
            $write("\n");
            $finish;
        end
    end

endmodule