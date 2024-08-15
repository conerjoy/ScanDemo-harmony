/**
 * @author 610965
 * @data 2024/8/15 16:19
 */
import { ProScanner } from '@ohos/Scanner'
import { promptAction, router } from '@kit.ArkUI'
import { ResultState } from '@ohos/Scanner/src/main/ets/components/Scanner'

@Entry
@Component
export struct ProScanPage {
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
      .height(44)
      .padding({ left: 10 })

      ProScanner({
        onScanResult: (code: ResultState, value: string) => {
          if (code == ResultState.Success) {
            promptAction.showToast({ message: value })
          }
        }
      })
        .layoutWeight(1)
    }
  }
}