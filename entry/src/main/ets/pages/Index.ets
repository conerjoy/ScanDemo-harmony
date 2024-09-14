import { ResultState, Scanner, ScannerController, ScanUtil } from '@ohos/Scanner';
import { promptAction, router } from '@kit.ArkUI';
import { scanCore } from '@kit.ScanKit';

@Entry
@Component
struct Index {
  scannerController: ScannerController = new ScannerController()

  onPageShow(): void {
    this.scannerController.rescan()
  }

  build() {
    Column() {
      RelativeContainer() {
        Text('扫一扫')
          .height(44)
          .id('title')
          .alignRules({
            middle: {
              anchor: '__container__',
              align: HorizontalAlign.Center
            }
          })

        Text('多码扫描')
          .alignSelf(ItemAlign.End)
          .height(44)
          .id('proScan')
          .alignRules({
            right: {
              anchor: '__container__',
              align: HorizontalAlign.End
            }
          })
          .onClick(() => {
            router.pushUrl({ url: 'pages/ProScanPage' })
          })
      }.width('100%')
      .height(80)
      .padding({ right: 10, top: 36 })

      Scanner({
        scanTypes: [scanCore.ScanType.QR_CODE],
        controller: this.scannerController,
        // lightShow: false,
        // albumsShow: false,
        // maskColor: Color.Transparent,
        // cornerLineShow: false,
        // scanLineShow: false,
        // tipsShow: false,
        // safeAreaType: [SafeAreaType.SYSTEM],
        // safeAreaEdge: [SafeAreaEdge.TOP],
        // luminanceListener: (percent) => {
        //   promptAction.showToast({message: percent >= 1 ? '显示手电筒' : '隐藏手电筒'})
        // },
        onScanResult: (code: ResultState, value: string) => {
          if (code == ResultState.Success) {
            promptAction.showToast({ message: value })
          }
        },
        onCameraReject: () => {
          promptAction.showToast({ message: '摄像头权限被拒绝' })
        }
      })
        // .width(200)
        // .height(200)
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
    ScanUtil.scanUri(uri, {
      scanTypes: [scanCore.ScanType.ALL]
    })
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