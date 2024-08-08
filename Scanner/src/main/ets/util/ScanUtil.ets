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
  scanUrl(url: string) {
    ImageUtil.saveImageByUrl(url, (uri) => {
      this.scanUri(uri)
    })
  }

  /**
   * 扫描图片PixelMap
   * @param pixelMap
   */
  scanPixelMap(pixelMap: PixelMap) {
    ImageUtil.saveImageByPixelMap(pixelMap, (uri) => {
      this.scanUri(uri)
    })
  }

  /**
   * 扫描uri
   * @param uri
   * @param options
   */
  scanUri(uri: string, options: scanBarcode.ScanOptions = {
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