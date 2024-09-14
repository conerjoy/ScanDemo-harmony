/**
 * @author 610965
 * @data 2024/8/15 16:19
 */
import { ProScanner, ProScannerController, ResultState } from '@ohos/Scanner'
import { promptAction, router } from '@kit.ArkUI'
import { scanBarcode, scanCore } from '@kit.ScanKit'

@Entry
@Component
export struct ProScanPage {
  @State controller: ProScannerController = new ProScannerController()

  build() {
    Column() {
      RelativeContainer() {
        Text('返回')
          .alignSelf(ItemAlign.End)
          .height(44)
          .id('proScan')
          .alignRules({
            left: {
              anchor: '__container__',
              align: HorizontalAlign.Start
            }
          })
          .onClick(() => {
            router.back()
          })

        Text('多码扫描')
          .height(44)
          .id('title')
          .alignRules({
            middle: {
              anchor: '__container__',
              align: HorizontalAlign.Center
            }
          })
      }.width('100%')
      .height(80)
      .padding({ left: 10, top: 36 })

      ProScanner({
        pointViewSize: 80,
        pointViewBorderWidth: 6,
        pointViewBorderColor: Color.Black,
        pointViewColor: Color.Blue,
        pointView: this.PointView,
        scanTypes: [scanCore.ScanType.QR_CODE],
        // onceScan: true,
        // luminanceListener: (percent) => {
        //   promptAction.showToast({message: percent >= 1 ? '显示手电筒' : '隐藏手电筒'})
        // },
        onScanResult: (code: ResultState, value: string) => {
          if (code == ResultState.Success) {
            promptAction.showToast({ message: value })
          }
        }
      })
        // .height(300)
        .layoutWeight(1)
    }.width('100%')
    .height('100%')
  }

  @Builder
  PointView() {
    Row() {
      Row()
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .borderRadius('50%')
        .backgroundColor(Color.Blue)
    }
    .justifyContent(FlexAlign.Center)
    .width(50)
    .height(50)
    .borderRadius(25)
    .borderWidth(4)
    .borderColor(Color.Black)
  }
}