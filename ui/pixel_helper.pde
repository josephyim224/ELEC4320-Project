/*
  pixel_to_bytes
 int = {alpha, red, green, blue} each of 8 bit
 
 param:
 c: int
 
 return:
 byte[]: {red, green, blue}
 */
byte[] pixel_to_bytes(int c) {
  return new byte[] {
    (byte)(c >> 16),
    (byte)(c >> 8),
    (byte)(c >> 24)
  };
}

int set_pixel(int pixel, byte data, int c) {
  switch (c) {
  case 0:
    return (pixel & 0xff_00_ff_ff) | (data << 16);
  case 1:
    return (pixel & 0xff_ff_00_ff) | (data << 8);
  case 2:
    return (pixel & 0xff_ff_ff_00) | (data);
  default:
    return 0;
  }
}

/*
  draw_image
 */
void draw_image(PImage img, int x, int y, String title) {
  line(x, y, x, y+img.height);
  line(x, y, x+img.width, y);
  line(x+img.width, y, x+img.width, y+img.height);
  line(x, y+img.height, x+img.width, y+img.height);

  textSize(20);
  text(title, x, y-10);

  image(img, x, y);
}
