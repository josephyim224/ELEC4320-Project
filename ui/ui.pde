import processing.serial.*;

PImage apple_img, orange_img, grape_img, src_image, result_image;
Serial serial;

/*
 is_read: is reading mode
 is_read_whole: is reading whole image
 read_x
 read_y
 read_c:
 0 for red
 1 for green
 2 for blue
 */
boolean is_read, is_read_whole;
int read_x, read_y, read_c;
byte state = 0;

void setup() {
  size(640, 640);

  apple_img = loadImage("../img/apple.png");
  orange_img = loadImage("../img/orange.png");
  grape_img = loadImage("../img/grape.png");

  src_image = apple_img;

  result_image = createImage(140, 140, ARGB);

  for (int i = 0; i < 140*140; ++i) {
    result_image.pixels[i] = 0xff_00_00_00;
  }

  is_read = false;
  is_read_whole = false;
  read_x = 0;
  read_y = 0;
  read_c = 0;

  printArray(Serial.list());
  if (use_serial) serial = new Serial(this, Serial.list()[0], 230400);

  println("init done");
}

void draw() {

  fill(255, 255, 255);
  rect(360, 120, 240, 40);

  // draw image
  draw_image(src_image, 0, 50, "original");
  draw_image(result_image, 150, 50, "result");

  // scaling factor
  draw_title(0, 200, "scale");
  draw_button(0, 240, "0.6");
  draw_button(0, 280, "0.8");
  draw_button(0, 320, "1.2");
  draw_button(0, 360, "1.4");

  // send data
  draw_title(120, 200, "source");
  draw_button(120, 240, "1 row");
  draw_button(120, 280, "all");

  // process
  draw_title(240, 200, "process");
  draw_button(240, 240, "run");

  // read data
  draw_title(360, 200, "result");
  draw_button(360, 240, "1 row");
  draw_button(360, 280, "all");
  draw_button(360, 320, "clear");

  // print data
  draw_button(480, 240, "R");
  draw_button(480, 280, "G");
  draw_button(480, 320, "B");

  // image
  draw_title(0, 440, "image");
  draw_button(0, 480, "apple");
  draw_button(0, 520, "orange");
  draw_button(0, 560, "grape");

  switch (state) {
  case 0:
    draw_title(360, 120, "reset done");
    break;
  case 1:
    draw_title(360, 120, "set scale done");
    break;
  case 3:
    draw_title(360, 120, "processing");
    break;
  case 4:
    draw_title(360, 120, "process done");
    break;
  case 5:
    draw_title(360, 120, "clear result done");
    break;
  case 6:
    draw_title(360, 120, "set source done");
    break;

  case 101:
    draw_title(360, 120, "set scale ing");
    break;
  case 102:
    draw_title(360, 120, "set source ing");
    break;
  case 104:
    draw_title(360, 120, "read image ing");
    break;
  case 105:
    draw_title(360, 120, "clear result ing");
    break;
  case 106:
    draw_title(360, 120, "set source ing");
    break;
  case 107:
    draw_title(360, 120, "read image done");
    break;
  }

  // serial
  while (serial != null && serial.available() > 0) {
    byte inByte = byte(serial.read());
    print(inByte);
    print(",");

    if (is_read) {
      result_image.pixels[140*read_y+read_x] = set_pixel(result_image.pixels[140*read_y+read_x], inByte, read_c);

      if (read_c < 2) {
        read_c+=1;
      } else {
        read_c = 0;
        read_x+=1;
      }

      if (read_x==140) {
        if (is_read_whole && read_y != 139) {
          read_y+=1;
          read_x=0;

          println("read data row ", read_y);
          uart_write(byte(4));
          uart_write(byte(read_y));
          println();
        } else {
          is_read=false;
          println("read data end");
          result_image.updatePixels();
          state = 107;
        }
      }
    } else {
      state = inByte;
    }
  }
}

void mousePressed() {
  // scaling factor
  if (is_in_button(0, 240)) {
    state = 101;
    println("scalling 0.6");

    uart_write(byte(1));
    uart_write(byte(0));

    println();
  } else if (is_in_button(0, 280)) {
    state = 101;
    println("scalling 0.8");

    uart_write(byte(1));
    uart_write(byte(1));

    println();
  } else if (is_in_button(0, 320)) {
    state = 101;
    println("scalling 1.2");

    uart_write(byte(1));
    uart_write(byte(2));

    println();
  } else if (is_in_button(0, 360)) {
    state = 101;
    println("scalling 1.4");

    uart_write(byte(1));
    uart_write(byte(3));

    println();
  }

  // send data
  if (is_in_button(120, 240)) {
    state = 102;
    println("send data 1 row");

    uart_write(byte(2));
    uart_write(byte(0));

    for (int i = 0; i < 100; ++i) {
      byte[] pixel = pixel_to_bytes(src_image.pixels[i]);
      uart_write(pixel[0]);
      uart_write(pixel[1]);
      uart_write(pixel[2]);
    }

    println();
  } else if (is_in_button(120, 280)) {
    state = 102;
    println("send data all");

    for (int y = 0; y < 100; ++y) {
      uart_write(byte(2));
      uart_write(byte(y));
      for (int x = 0; x < 100; ++x) {
        byte[] pixel = pixel_to_bytes(src_image.pixels[100*y+x]);
        uart_write(pixel[0]);
        uart_write(pixel[1]);
        uart_write(pixel[2]);
      }
    }

    println();
  }

  // process
  if (is_in_button(240, 240)) {
    println("process");

    uart_write(byte(3));

    println();
  }

  // read data
  if (is_in_button(360, 240)) {
    state = 104;
    println("read data 1 row");

    read_x = 0;
    read_y = 0;
    read_c = 0;

    is_read = true;
    is_read_whole = false;

    uart_write(byte(4));
    uart_write(byte(0));

    println();
  } else if (is_in_button(360, 280)) {
    state = 104;
    println("read data all");

    read_x = 0;
    read_y = 0;
    read_c = 0;

    is_read = true;
    is_read_whole = true;

    uart_write(byte(4));
    uart_write(byte(0));

    println();
  } else if (is_in_button(360, 320)) {
    state = 105;
    uart_write(byte(5));
    println();
  }

  // print data
  if (is_in_button(480, 240)) {
    println("memory_initialization_radix=10;\nmemory_initialization_vector=\n");
    for (int y = 0; y < 100; ++y) {
      for (int x = 0; x < 100; ++x) {
        byte[] pixel = pixel_to_bytes(src_image.pixels[100*y+x]);
        print(pixel[0]);
        print(",");
      }
    }
    println(";");
  } else if (is_in_button(480, 280)) {
    println("memory_initialization_radix=10;\nmemory_initialization_vector=\n");
    for (int y = 0; y < 100; ++y) {
      for (int x = 0; x < 100; ++x) {
        byte[] pixel = pixel_to_bytes(src_image.pixels[100*y+x]);
        print(pixel[1]);
        print(",");
      }
    }
    println(";");
  } else if (is_in_button(480, 320)) {
    println("memory_initialization_radix=10;\nmemory_initialization_vector=\n");
    for (int y = 0; y < 100; ++y) {
      for (int x = 0; x < 100; ++x) {
        byte[] pixel = pixel_to_bytes(src_image.pixels[100*y+x]);
        print(pixel[2]);
        print(",");
      }
    }
    println(";");
  }

  if (is_in_button(0, 480)) {
    src_image = apple_img;
  } else if (is_in_button(0, 520)) {
    src_image = orange_img;
  } else if (is_in_button(0, 560)) {
    src_image = grape_img;
  }
}
