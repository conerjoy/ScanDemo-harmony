import { Scanner, ScannerController } from '@ohos/Scanner';
import { promptAction } from '@kit.ArkUI';
import { ResultState } from '@ohos/Scanner/src/main/ets/components/Scanner';

@Entry
@Component
struct Index {
  scannerController: ScannerController = new ScannerController()

  scanNetImage(url: string) {
    this.scannerController.scanUrl(url)
  }

  scanPixelMap(pixelMap: PixelMap) {
    this.scannerController.scanPixelMap(pixelMap)
  }

  build() {
    Column() {
      Text('扫一扫')
        .height(44)

      Scanner({
        // cornerLineShow: false, // 隐藏四个角
        // scanLineShow: false, // 隐藏扫描线
        // albumsShow: false, // 隐藏图库按钮和文字
        // lightShow: false, // 隐藏闪光点按钮和文字
        // tipsShow: false, // 隐藏提示词
        // maskColor: Color.Transparent, // 蒙层透明
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
}