import { ImageUtil } from './ImageUtil'
import { detectBarcode, scanBarcode, scanCore } from '@kit.ScanKit'
import { BusinessError } from '@kit.BasicServicesKit'

/**
 * @author coner
 * @data 2024/8/8 23:36
 */
export class ScanUtil {
  /**
   * 扫描网络url
   * @param url
   */
  static async scanUrl(url: string, options: scanBarcode.ScanOptions = {
    scanTypes: [scanCore.ScanType.ALL],
    enableMultiMode: true,
    enableAlbum: true
  }): Promise<string> {
    const uri = await ImageUtil.saveImageByUrl(url)
    return ScanUtil.scanUri(uri, options)
  }

  /**
   * 扫描图片PixelMap
   * @param pixelMap
   */
  static async scanPixelMap(pixelMap: PixelMap, options: scanBarcode.ScanOptions = {
    scanTypes: [scanCore.ScanType.ALL],
    enableMultiMode: true,
    enableAlbum: true
  }): Promise<string> {
    const uri = await ImageUtil.saveImageByPixelMap(pixelMap)
    return ScanUtil.scanUri(uri, options)
  }

  /**
   * 扫描uri
   * @param uri
   * @param options
   */
  static scanUri(uri: string, options: scanBarcode.ScanOptions = {
    scanTypes: [scanCore.ScanType.ALL],
    enableMultiMode: true,
    enableAlbum: true
  }): Promise<string> {
    return new Promise((resolve, reject) => {
      // 定义识码参数inputImage，其中uri为picker选择图片
      let inputImage: detectBarcode.InputImage = { uri: uri }
      // 调用图片识码接口
      detectBarcode.decode(inputImage, options).then((result: Array<scanBarcode.ScanResult>) => {
        if (result != undefined) {
          let scanCodeRect = result[0]?.scanCodeRect;
          if (scanCodeRect != undefined) {
            if (result[0]?.originalValue != undefined) {
              resolve(result[0]?.originalValue ?? '')
            } else {
              reject('scan error')
            }
            return
          }
        }
        reject('scan error')
      }).catch((error: BusinessError) => {
        reject(error.message)
      })
    })
  }
}