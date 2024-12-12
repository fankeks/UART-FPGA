`timescale 1ns/1ps


module test;
  // Подключение
  logic clk;
  logic clk_baud;
  logic rst;
  logic rx;
  wire [7:0] data;
  wire valid;

  parameter BOADRATE_PARAM = 115200;
  uart_rx_writer #(.boadrate(BOADRATE_PARAM)) mrx1 (.clk(clk), .rst(rst), .rx(rx), .data(data), .valid(valid));

  initial begin
    $dumpfile("UART_RX.vcd");
    $dumpvars;
  end

  // Генерация clk
  parameter CLK_PERIOD = 20; // 50 МГц
  initial begin
    clk <= 0;
    forever begin
      #(CLK_PERIOD / 2); clk <= ~clk;
    end
  end

  initial begin
    clk_baud <= 0;
    forever begin
      #(1000_000_000 / BOADRATE_PARAM); clk_baud <= ~clk_baud;
    end
  end

  //Генерация rst
  initial begin
    rst <= 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    rst <= 0;
  end

  // Генерация входных сигналов
  initial begin
    rx <= 1;
    wait(rst);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    // Старт бит
    rx <= 0;
    @(clk_baud);

    // Данные
    // 1
    rx <= 1;
    @(clk_baud);
    // 2
    rx <= 0;
    @(clk_baud);
    // 3
    rx <= 1;
    @(clk_baud);
    // 4
    rx <= 0;
    @(clk_baud);
    // 5
    rx <= 1;
    @(clk_baud);
    // 6
    rx <= 0;
    @(clk_baud);
    // 7
    rx <= 1;
    @(clk_baud);
    // 8
    rx <= 0;
    @(clk_baud);

    // Стоп бит
    rx <= 1;
    @(clk_baud);

    // Старт бит
    rx <= 0;
    @(clk_baud);

    // Данные
    // 1
    rx <= 0;
    @(clk_baud);
    // 2
    rx <= 0;
    @(clk_baud);
    // 3
    rx <= 0;
    @(clk_baud);
    // 4
    rx <= 0;
    @(clk_baud);
    // 5
    rx <= 1;
    @(clk_baud);
    // 6
    rx <= 1;
    @(clk_baud);
    // 7
    rx <= 1;
    @(clk_baud);
    // 8
    rx <= 1;
    @(clk_baud);

    // Стоп бит
    rx <= 1;
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    $finish;
  end
endmodule