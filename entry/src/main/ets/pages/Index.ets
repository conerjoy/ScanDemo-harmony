import { Scanner } from '@ohos/Scanner';
import { ScannerController } from '@ohos/Scanner/src/main/ets/components/Scanner';

@Entry
@Component
struct Index {
  scannerController: ScannerController = new ScannerController()

  build() {
    Column() {
      Text('扫一扫')
        .height(44)

      Scanner({
        albumsShow: true, // 相册是否显示
        albumsIcon: $r('app.media.scanner_albums'), // 相册图标
        albumsIconSize: 64, // 相册图标大小
        albumsText: '相册', // 相册文案
        albumsTextSize: 16, // 相册文案文字大小
        albumsTextColor: Color.White, // 相册文案颜色
        lightShow: true, // 手电筒是否显示
        lightCloseIcon: $r('app.media.scanner_light_close'), // 手电筒关闭图标
        lightOpenIcon: $r('app.media.scanner_light_open'), // 手电筒开启图标
        lightIconSize: 64, // 手电筒图标大小
        lightOpenText: '开灯', // 手电筒开启文案
        lightCloseText: '关灯', // 手电筒关闭文案
        lightTextSize: 16, // 手电筒文字大小
        lightTextColor: Color.White, // 手电筒文案颜色
        tipsShow: true, // 提示词是否显示
        tips: '将条码、二维码放入框内，即可自动扫描', // 提示词内容
        tipsTextColor: Color.White, // 提示词文字颜色
        tipsTextSize: 14, // 提示词文字大小
        tipsTopMargin: 10, // 提示词距离上面的间距
        maskColor: '#7f000000', // 遮罩颜色
        scannerSize: 256, // 扫描框宽高
        cornerLineWidth: 3, // 角上的框宽度
        cornerLineLength: 30, // 角上的框长度
        cornerLineColor: Color.White, // 角上的框颜色
        scanTopMargin: 100, // 扫描框距离上面的间距
        scanLineWidth: 1, // 扫描线宽度
        scanLineLength: '100%', // 扫描线长度
        scanLineColor: Color.White, // 扫描线颜色
        scanLineShow: true, // 扫描线是否显示
        scanAnimTime: 1500, // 动画时间
        scanIntervalTime: 1000, // 扫码间隔时间
        disableCheckArea: false, // 是否禁止检查二维码在框中
        areaOffset: 100, // 二维码在框中的偏移量
        controller: this.scannerController,
      })
        .layoutWeight(1)
    }.width('100%')
    .height('100%')
  }
}