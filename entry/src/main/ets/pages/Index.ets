import { Scanner, ScannerController, ScanUtil } from '@ohos/Scanner';
import { promptAction } from '@kit.ArkUI';
import { ResultState } from '@ohos/Scanner/src/main/ets/components/Scanner';

@Entry
@Component
struct Index {
  scannerController: ScannerController = new ScannerController()

  build() {
    Column() {
      Text('扫一扫')
        .height(44)

      Scanner({
        controller: this.scannerController,
        onScanResult: (code: ResultState, value: string) => {
          if (code == ResultState.Success) {
            promptAction.showToast({ message: value })
          }
        },
        onCameraReject: () => {
          promptAction.showToast({ message: '摄像头权限被拒绝' })
        },
        onMediaReject: () => {
          promptAction.showToast({ message: '图库权限被拒绝' })
        }
      })
        .layoutWeight(1)
    }.width('100%')
    .height('100%')
  }

  /**
   * 扫描图片uri
   * 扫码页面使用扫一扫能力，扫描结果通过Scanner组件回调
   * @param url
   */
  scanUri(uri: string) {
    this.scannerController.scanUri(uri)
  }

  /**
   * 扫描图片uri
   * 非扫码页面使用扫一扫能力，扫描结果promise回调
   * @param url
   */
  scanUri2(uri: string) {
    ScanUtil.scanUri(uri)
      .then((res) => {
        promptAction.showToast({ message: res })
      })
      .catch((err: string) => {
        promptAction.showToast({ message: '失败了：' + err })
      })
  }

  /**
   * 扫描网络图片
   * 扫码页面使用扫一扫能力，扫描结果通过Scanner组件回调
   * @param url
   */
  scanNetImage(url: string) {
    this.scannerController.scanUrl(url)
  }

  /**
   * 扫描网络图片
   * 非扫码页面使用扫一扫能力，扫描结果promise回调
   * @param url
   */
  scanNetImage2(url: string) {
    ScanUtil.scanUrl(url)
      .then((res) => {
        promptAction.showToast({ message: res })
      })
      .catch((err: string) => {
        promptAction.showToast({ message: '失败了：' + err })
      })
  }

  /**
   * 扫描图片PixelMap
   * 扫码页面使用扫一扫能力，扫描结果通过Scanner组件回调
   * @param url
   */
  scanPixelMap(pixelMap: PixelMap) {
    this.scannerController.scanPixelMap(pixelMap)
  }

  /**
   * 扫描图片PixelMap
   * 非扫码页面使用扫一扫能力，扫描结果promise回调
   * @param url
   */
  scanPixelMap2(pixelMap: PixelMap) {
    ScanUtil.scanPixelMap(pixelMap)
      .then((res) => {
        promptAction.showToast({ message: res })
      })
      .catch((err: string) => {
        promptAction.showToast({ message: '失败了：' + err })
      })
  }
}