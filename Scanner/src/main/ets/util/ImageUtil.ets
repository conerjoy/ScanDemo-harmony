/**
 * @author 610965
 * @data 2024/8/8 9:35
 */
import { http } from '@kit.NetworkKit'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@kit.BasicServicesKit'
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { buffer } from '@kit.ArkTS';
import { fileUri } from '@kit.CoreFileKit';


// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let cacheDir = context.cacheDir;

export class ImageUtil {
  static async saveImageByUrl(url: string, callback: (uri: string) => void) {
    const pixelMap = await urlToPixelMap(url)
    ImageUtil.saveImageByPixelMap(pixelMap, callback)
  }

  static async saveImageByPixelMap(pixelMap: PixelMap, callback: (uri: string) => void) {
    const uri = await ImageUtil.createImageFile(pixelMap)
    callback(uri)
  }

  static async createImageFile(pixelMap: PixelMap): Promise<string> {
    const arr = await getPixelMapInt32ArrayData(pixelMap)
    // 新建并打开文件
    let file = fs.openSync(cacheDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // 写入一段内容至文件
    let writeLen = fs.writeSync(file.fd, arr);
    console.info("The length of str is: " + writeLen);
    // 从文件读取一段内容
    let arrayBuffer = new ArrayBuffer(1024);

    class Option {
      public offset: number = 0;
      public length: number = 0;
    }

    let option = new Option();
    option.length = arrayBuffer.byteLength;
    let readLen = fs.readSync(file.fd, arrayBuffer, option);
    let buf = buffer.from(arrayBuffer, 0, readLen);
    console.info("the content of file: " + buf.toString());
    // 关闭文件
    fs.closeSync(file);
    const uri = fileUri.getUriFromPath(file.path)
    return uri
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