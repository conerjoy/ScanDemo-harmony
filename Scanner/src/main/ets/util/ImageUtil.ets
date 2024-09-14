/**
 * @author 610965
 * @data 2024/8/8 9:35
 */
import { http } from '@kit.NetworkKit'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@kit.BasicServicesKit'
import common from '@ohos.app.ability.common';
import { fileIo, fileUri } from '@kit.CoreFileKit';


// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let cacheDir = context.cacheDir;
const scanImageName = 'scan-step.jpg' // 沙盒内固定名称图片文件

export class ImageUtil {
  static async saveImageByUrl(url: string): Promise<string> {
    const pixelMap = await urlToPixelMap(url)
    return ImageUtil.saveImageByPixelMap(pixelMap)
  }

  static async saveImageByPixelMap(pixelMap: PixelMap): Promise<string> {
    const uri = await ImageUtil.createImageFile(pixelMap)
    return uri
  }

  static async createImageFile(pixelMap: PixelMap): Promise<string> {
    const imgBuffer = await ImageUtil.transferPixelMap2Buffer(pixelMap)
    const file = fileIo.openSync(cacheDir + '/' + scanImageName,
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    await fileIo.write(file.fd, imgBuffer);
    await fileIo.close(file.fd);
    const uri = fileUri.getUriFromPath(file.path)
    return uri
  }

  // 将pixelMap转成图片格式
  static transferPixelMap2Buffer(pixelMap: image.PixelMap): Promise<ArrayBuffer> {
    return new Promise((resolve, reject) => {
      /**
       * 设置打包参数
       * format：图片打包格式，只支持 jpg 和 webp
       * quality：JPEG 编码输出图片质量
       * bufferSize：图片大小，默认 10M
       */
      let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
      // 创建ImagePacker实例
      const imagePackerApi = image.createImagePacker();
      imagePackerApi.packing(pixelMap, packOpts).then((buffer: ArrayBuffer) => {
        resolve(buffer);
      }).catch((err: BusinessError) => {
        reject();
      })
    })
  }
}

export function getPixelMapInt32ArrayData(pixelMap: PixelMap): Promise<Int32Array> {
  return new Promise<Int32Array>((resolve, reject) => {
    // 读取新创建的PixelMap
    let pixelBytesNumber: number = pixelMap.getPixelBytesNumber()
    console.log('getPixelMapInt32ArrayData pixelBytesNumber: ' + pixelBytesNumber);
    let readPixelsToBuffer = new ArrayBuffer(pixelBytesNumber);
    let readPixelsToUnit8Arr: Int32Array = new Int32Array(readPixelsToBuffer);
    pixelMap.readPixelsToBuffer(readPixelsToBuffer, (InfoErr, InfoData) => {
      if (InfoErr) {
        console.warn('getPixelMapInt32ArrayData error code is  ' + InfoErr.code);
        console.warn('getPixelMapInt32ArrayData error msg is ' + InfoErr.message);
        reject(InfoErr)
      } else {
        console.log('getPixelMapInt32ArrayData success');
        console.log('getPixelMapInt32ArrayData readPixelsToUnit8Arr size:' + readPixelsToUnit8Arr.length);
        console.log('getPixelMapInt32ArrayData readPixelsToUnit8Arr:' + JSON.stringify(readPixelsToUnit8Arr));
        resolve(readPixelsToUnit8Arr);
      }
    });
  })
}

export function urlToPixelMap(url: string): Promise<PixelMap> {
  return new Promise<PixelMap>((resolve, reject) => {
    http.createHttp().request(url, { expectDataType: http.HttpDataType.ARRAY_BUFFER }).then(async (res) => {
      // 将图片资源转为像素图（PixelMap）
      let pixelMap = await image.createImageSource(res.result as ArrayBuffer)
        .createPixelMap()
      resolve(pixelMap)
    }).catch((err: BusinessError) => {
      reject(err)
    })
  })
}

/**
 * 计算明亮度
 * @param pixelMap
 * @returns
 */
export async function calculateLuminance(pixelMap: PixelMap, precise: boolean = false): Promise<number> {
  let pixelBytesNumber: number = pixelMap.getPixelBytesNumber()
  let readPixelsToBuffer = new ArrayBuffer(pixelBytesNumber);
  await pixelMap.readPixelsToBuffer(readPixelsToBuffer)
  const unit8Pixels: Uint8Array = new Uint8Array(readPixelsToBuffer);
  let darkCount = 0
  const step = precise ? 4 : 16
  const sum = precise ? 0.25 : 0.0625
  for (let i = 0; i < unit8Pixels.length; i += step) {
    const red = unit8Pixels[i+2];
    const green = unit8Pixels[i+1];
    const blue = unit8Pixels[i];
    const alpha = unit8Pixels[i+3]
    // 计算Luminance值
    // const luminance = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
    const luminance = (0.3 * red + 0.59 * green + 0.11 * blue);
    // 根据luminance值进行灰阶值分割
    if (luminance < 128) {
      // 低于128的部分为黑色
      darkCount++
    } else {
      // 高于或等于128的部分为白色
    }
  }
  return (darkCount / unit8Pixels.length) / sum
}