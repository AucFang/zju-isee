/////////////////////////////////////////////////////////////////////////
// Bitmap点阵数据表                                                    //
// 图片: F:\..件\葫芦娃.bmp,横向取模左高位,数据排列:从左到右从上到下   //
// 图片尺寸: 128 * 64                                                  //
/////////////////////////////////////////////////////////////////////////
unsigned char code nBitmapDot[] =                  // 数据表
{
      0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
      0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x00,0x01,0xC0,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x00,0x01,0xB8,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x00,0x01,0xCF,0xFF,0x00,0x00,0x00,0x01,
      0x80,0x00,0xE0,0x00,0x00,0x00,0x00,0x40,
      0x00,0x00,0x8F,0xFF,0xC0,0x00,0x00,0x01,
      0x80,0x00,0xC0,0x00,0x00,0x00,0x00,0x40,
      0x00,0x00,0xBF,0xFF,0xE0,0x00,0x00,0x01,
      0x80,0x00,0xC0,0x00,0x7F,0x9F,0xF8,0x40,
      0x00,0x00,0xBF,0xFF,0xF0,0x00,0x00,0x01,
      0x80,0x00,0xC0,0x00,0x7F,0x1F,0xF8,0x40,
      0x00,0x0F,0x7F,0xFF,0x08,0x00,0x00,0x01,
      0x80,0x00,0xC0,0x00,0x03,0x18,0x18,0x40,
      0x00,0x0F,0x7F,0x00,0x08,0x00,0x00,0x01,
      0x80,0x00,0xC0,0x00,0x03,0x18,0x18,0x40,
      0x00,0x03,0x7F,0x00,0x08,0x00,0x00,0x01,
      0x80,0x30,0xC2,0x00,0x03,0x1F,0xF8,0x40,
      0x00,0x0F,0xFF,0x80,0x68,0x00,0x00,0x01,
      0x80,0x38,0xC7,0x00,0x7F,0x1F,0xF8,0x40,
      0x00,0x0F,0x7F,0x8F,0xA8,0x00,0x00,0x01,
      0x80,0x70,0xC3,0x80,0x7F,0x03,0x00,0x40,
      0x00,0x02,0x7F,0x87,0xE8,0x00,0x00,0x01,
      0x80,0x60,0xC1,0x80,0x60,0x03,0x00,0x40,
      0x00,0x00,0x7B,0x85,0xF8,0x00,0x00,0x01,
      0x80,0x60,0xC1,0xC0,0xE0,0x3F,0xFC,0x40,
      0x00,0x00,0x7F,0x87,0xE8,0x00,0x00,0x01,
      0x80,0xE0,0xC0,0xC0,0x60,0x3F,0xFC,0x40,
      0x00,0x00,0x7D,0xC0,0x18,0x00,0x00,0x01,
      0x80,0xC0,0xC0,0xE0,0x7F,0xB3,0x0C,0x40,
      0x00,0x01,0xFF,0xC0,0x20,0x00,0xA0,0x01,
      0x81,0xC0,0xC0,0x60,0x7F,0x33,0x0C,0x40,
      0x00,0x05,0xFF,0xC0,0x24,0x00,0xF0,0x01,
      0x81,0x80,0xC0,0x70,0x03,0x3F,0xFC,0x40,
      0x00,0x07,0x7F,0xC0,0x3C,0x1D,0x70,0x01,
      0x83,0x80,0xC0,0x60,0x03,0x3F,0xFC,0x40,
      0x00,0x03,0xFE,0x3F,0xE4,0x0B,0x38,0x01,
      0x80,0x00,0xC0,0x00,0x03,0x33,0x0C,0x40,
      0x00,0x02,0x8A,0x0F,0xC4,0x09,0x38,0x01,
      0x80,0x00,0xC0,0x00,0x03,0x33,0x18,0x40,
      0x00,0x03,0xC4,0xC2,0xA7,0x08,0x38,0x01,
      0x80,0x00,0xC0,0x00,0x03,0x03,0x0C,0x40,
      0x00,0x02,0x24,0xFF,0xA4,0xD8,0x18,0x01,
      0x80,0x07,0xC0,0x00,0x07,0x03,0xFC,0x40,
      0x00,0x0C,0x32,0x48,0xE0,0x00,0x60,0x01,
      0x80,0x07,0xC0,0x00,0x7E,0x7F,0xFE,0x40,
      0x00,0x60,0x11,0x00,0x60,0x00,0x80,0x01,
      0x80,0x03,0x00,0x00,0x3C,0x7C,0x06,0x40,
      0x00,0x40,0x01,0xA0,0xE8,0x00,0x80,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x04,0x40,
      0x01,0x00,0x08,0x70,0x68,0x03,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x0C,0x00,0x08,0x33,0x78,0x04,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x28,0x00,0x08,0x17,0xFF,0x0C,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0xD0,0x01,0xC0,0x50,0xD0,0x70,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0xC0,0x03,0xC8,0x50,0xD0,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x43,
      0x30,0x38,0x20,0x20,0xE0,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x4C,
      0xA4,0xC0,0x20,0x31,0x20,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x4F,
      0x35,0x80,0x30,0x01,0x40,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0xCC,0x00,0x38,0x3F,0x20,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x10,0x00,0x40,0x00,0x30,0x00,0x00,0x01,
      0x80,0x01,0xC0,0x00,0x00,0x00,0x00,0x40,
      0x00,0x00,0xC0,0x04,0x50,0x00,0x00,0x01,
      0x80,0x01,0x80,0x00,0x1F,0xFF,0xF0,0x40,
      0x00,0x01,0x08,0x06,0x28,0x00,0x00,0x01,
      0x80,0x01,0x80,0x00,0x1F,0xFF,0xF0,0x40,
      0x00,0x02,0x38,0x07,0x2C,0x00,0x00,0x01,
      0x80,0x01,0x80,0x00,0x00,0x01,0xE0,0x40,
      0x00,0x07,0xB4,0x1C,0xCA,0x00,0x00,0x01,
      0x81,0xFF,0xFF,0x00,0x00,0x03,0x80,0x40,
      0x00,0x0D,0x91,0x6B,0x7F,0x80,0x00,0x01,
      0x81,0xFF,0xFF,0x00,0x00,0x07,0x00,0x40,
      0x00,0x0D,0xC9,0x58,0x58,0xC0,0x00,0x01,
      0x81,0x81,0x83,0x00,0x00,0x1C,0x00,0x40,
      0x00,0x0E,0x37,0x29,0xC0,0x20,0x00,0x01,
      0x81,0x81,0x83,0x00,0x00,0x18,0x00,0x40,
      0x00,0x09,0xF8,0xFE,0x01,0xE0,0x00,0x01,
      0x81,0x81,0x83,0x00,0x00,0x18,0x00,0x40,
      0x00,0x10,0xC0,0xEC,0x0F,0x80,0x00,0x01,
      0x81,0xFF,0xFF,0x00,0x00,0x18,0x00,0x40,
      0x00,0x30,0x01,0x02,0xF5,0xC0,0x00,0x01,
      0x81,0xFF,0xFF,0x00,0x7F,0xFF,0xFE,0x40,
      0x00,0x20,0x02,0x01,0xF7,0x00,0x00,0x01,
      0x81,0x81,0x83,0x00,0x7F,0xFF,0xFE,0x40,
      0x00,0x40,0x04,0x00,0xE0,0x40,0x00,0x01,
      0x81,0x81,0x83,0x00,0x00,0x18,0x00,0x40,
      0x00,0x70,0x08,0x00,0x80,0x40,0x00,0x01,
      0x81,0x81,0x83,0x00,0x00,0x18,0x00,0x40,
      0x00,0xBC,0x10,0x00,0x80,0xC0,0x00,0x01,
      0x81,0xFF,0xFF,0x00,0x00,0x18,0x00,0x40,
      0x00,0xF3,0xE0,0x00,0x80,0xC0,0x00,0x01,
      0x81,0xFF,0xFF,0x00,0x00,0x18,0x00,0x40,
      0x01,0x83,0xE0,0x00,0x80,0x3E,0x00,0x01,
      0x81,0x81,0x83,0x00,0x00,0x18,0x00,0x40,
      0x01,0x00,0xE0,0x00,0x00,0x2E,0x00,0x01,
      0x81,0x81,0x80,0x40,0x00,0x18,0x00,0x40,
      0x00,0x01,0x00,0x01,0x00,0x1E,0x00,0x01,
      0x80,0x01,0x80,0x30,0x00,0x18,0x00,0x40,
      0x02,0x00,0x00,0x01,0x3F,0xFC,0x00,0x01,
      0x80,0x01,0x80,0x70,0x00,0x18,0x00,0x40,
      0x02,0x02,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x01,0xFF,0xE0,0x00,0xF8,0x00,0x40,
      0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0xFF,0xC0,0x00,0xF0,0x00,0x40,
      0x04,0x24,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x0E,0xF8,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x0E,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
      0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x40,
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x13,
      0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
      0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
};
