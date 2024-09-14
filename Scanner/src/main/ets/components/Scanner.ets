/**
 * @author 610965
 * @data 2024/8/5 14:56
 */
import { ScanBottomLeftRect, ScanBottomRightRect, ScanTopLeftRect, ScanTopRightRect } from './ScanRectView'
import { customScan, scanBarcode, scanCore } from '@kit.ScanKit'
import { display } from '@kit.ArkUI'
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit'
import { requestPermissionsFromUser } from '../util/PermissionUtil'
import { common } from '@kit.AbilityKit'
import { picker } from '@kit.CoreFileKit'
import { ScanUtil } from '../util/ScanUtil'
import { ScannerControllerInterface } from '../util/ScannerControllerInterface'
import { ResultState } from '../util/ResultState'
import { image } from '@kit.ImageKit'
import { calculateLuminance } from '../util/ImageUtil'

@Component
export struct Scanner {
  // ----------------------------------参数----------------------------------
  @Prop albumsShow: boolean = true // 相册是否显示
  @Prop albumsIcon: ResourceStr = $r('app.media.scanner_albums') // 相册图标
  @Prop albumsIconSize: Length = 64 // 相册图标大小
  @Prop albumsText: string = '相册' // 相册文案
  @Prop albumsTextSize: Length = 16 // 相册文案文字大小
  @Prop albumsTextColor: ResourceColor = Color.White // 相册文案颜色
  @Prop lightShow: boolean = true // 手电筒是否显示
  @Prop lightCloseIcon: ResourceStr = $r('app.media.scanner_light_close') // 手电筒关闭图标
  @Prop lightOpenIcon: ResourceStr = $r('app.media.scanner_light_open') // 手电筒开启图标
  @Prop lightIconSize: Length = 64 // 手电筒图标大小
  @Prop lightOpenText: string = '开灯' // 手电筒开启文案
  @Prop lightCloseText: string = '关灯' // 手电筒关闭文案
  @Prop lightTextSize: Length = 16 // 手电筒文字大小
  @Prop lightTextColor: ResourceColor = Color.White // 手电筒文案颜色
  @Prop tipsShow: boolean = true // 提示词是否显示
  @Prop tips: string = '将条码、二维码放入框内，即可自动扫描' // 提示词内容
  @Prop tipsTextColor: ResourceColor = Color.White // 提示词文字颜色
  @Prop tipsTextSize: Length = 14 // 提示词文字大小
  @Prop tipsTopMargin: Length = 10 // 提示词距离上面的间距
  @Prop maskColor: ResourceColor = '#7f000000' // 遮罩颜色
  @Prop scannerSize: number = 256 // 扫描框宽高
  @Prop cornerLineWidth: number = 3 // 角上的框宽度
  @Prop cornerLineLength: number = 30 // 角上的框长度
  @Prop cornerLineColor: ResourceColor = Color.White // 角上的框颜色
  @Prop cornerLineShow: boolean = true // 四个角是否显示
  @Prop scanTopMargin: number = 100 // 扫描框距离上面的间距
  @Prop scanLineWidth: Length = 1 // 扫描线宽度
  @Prop scanLineLength: Length = '100%' // 扫描线长度
  @Prop scanLineColor: ResourceColor = Color.White // 扫描线颜色
  @Prop scanLineShow: boolean = true // 扫描线是否显示
  @Prop scanAnimTime: number = 1500 // 动画时间
  @Prop scanIntervalTime: number = 1000 // 扫码间隔时间
  @Prop onceScan: boolean = false // 是否单次扫描
  @Prop scanTypes: Array<scanCore.ScanType> = [scanCore.ScanType.ALL] // 扫描类型
  @Prop safeAreaType?: Array<SafeAreaType> = [SafeAreaType.SYSTEM]
  @Prop safeAreaEdge?: Array<SafeAreaEdge> = [SafeAreaEdge.BOTTOM]
  @Prop luminanceAnalyzerInterval: number = 1000 // 亮度检测时间间隔
  luminanceListener?: (luminance: number) => void // 亮度检测监听
  disableCheckArea: boolean = false // 是否禁止检查二维码在框中
  areaOffset: number = 100 // 二维码在框中的偏移量
  controller?: ScannerController // 扫码控制类
  onScanResult?: (code: ResultState, value: string) => void; //扫码结果回调函数
  onCameraGrant?: () => void // 摄像头权限同意回调
  onCameraReject?: () => void // 摄像头权限拒绝回调
  // ------------------------------------------------------------------------
  @State scanLineY: number = 0
  private mXComponentController: XComponentController = new XComponentController()
  private surfaceId?: string; //内部实现，不需要初始化
  private viewControl?: customScan.ViewControl ///内部实现，不需要初始化
  private defaultWidth: number = 360
  private defaultHeight: number = 640
  @State screenWidth: number = this.defaultWidth
  @State screenHeight: number = this.defaultHeight
  @State @Watch("startScan") isLoaded: boolean = false //相机组件是否加载成功
  @State isLightOpen: boolean = false //打开闪光灯
  @State scanRectLeftBoundary: number = 0
  @State scanRectRightBoundary: number = 0
  @State scanRectTopBoundary: number = 0
  @State scanRectBottomBoundary: number = 0
  @State firstShow: boolean = true // 页面第一次显示
  @State isRelease: boolean = false // 是否已经回收资源了
  @State isFirstScanSuccess: boolean = false // 是否第一次扫码成功
  private luminanceAnalyzerId: number = 0 // 亮度分析任务id
  private callback: AsyncCallback<scanBarcode.ScanResult[]> = async (error: BusinessError, result: scanBarcode.ScanResult[]) => {
    if (this.isRelease) {
      return
    }
    if (error) {
      console.warn(`扫描错误, code: ${error.code}, message: ${error.message}`);
      this.onScanResult?.(ResultState.Fail, error.message);
      if (!this.isRelease) {
        this.rescan()
      }
      return;
    }

    console.log(`扫描成功, result: ${JSON.stringify(result)}`);
    if (result) {
      let scanCodeRect = result[0]?.scanCodeRect;
      if (scanCodeRect != undefined && (this.disableCheckArea || this.isInScanRect(px2vp(scanCodeRect.left), px2vp(scanCodeRect.top), px2vp(scanCodeRect.right), px2vp(scanCodeRect.bottom)))) {
        if (result[0]?.originalValue != undefined) {
          if (this.onceScan) {
            if (!this.isFirstScanSuccess) {
              this.onScanResult?.(ResultState.Success, result[0]?.originalValue);
            }
            this.isFirstScanSuccess = true
          } else {
            this.onScanResult?.(ResultState.Success, result[0]?.originalValue);
          }
        } else {
          this.onScanResult?.(ResultState.Fail, '扫描错误');
        }
      }
    }
    if (!this.isRelease) {
      this.rescan()
    }
  }

  aboutToAppear(): void {
    this.controller?.init(this)
    this.scanRectLeftBoundary = (this.screenWidth - this.scannerSize) / 2.0 //扫码框左边的边距
    this.scanRectRightBoundary = this.scanRectLeftBoundary + this.scannerSize //扫码框右边的边距
    this.scanRectTopBoundary = this.scanTopMargin + this.cornerLineWidth //扫码框顶部的边距
    this.scanRectBottomBoundary = this.scanRectTopBoundary + this.scannerSize //扫码框底部的边距
  }

  aboutToDisappear(): void {
    this.releaseScan()
  }

  /**
   * 选择图片识别二维码
   */
  pickPhoto() {
    // 通过picker拉起图库的图片
    let photoOption = new picker.PhotoSelectOptions();
    photoOption.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    photoOption.maxSelectNumber = 1;
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select(photoOption).then((result) => {
      this.scanUri(result.photoUris[0])
    })
  }

  /**
   * 打开闪光灯
   */
  openLight() {
    if (this.isLoaded && !this.isLightOpen) {
      try {
        customScan.openFlashLight()
      } catch (e) {
        console.warn(e)
      }
      this.isLightOpen = true
    }
  }

  /**
   * 关闭闪光灯
   */
  closeLight() {
    if (this.isLoaded && this.isLightOpen) {
      try {
        customScan.closeFlashLight()
      } catch (e) {
        console.warn(e)
      }
      this.isLightOpen = false
    }
  }

  /**
   * 闪光点开关
   */
  toggleLight() {
    if (this.isLoaded) {
      try {
        if (this.isLightOpen) {
          customScan.closeFlashLight()
        } else {
          customScan.openFlashLight()
        }
      } catch (e) {
        console.warn(e)
      }
      this.isLightOpen = !this.isLightOpen
    }
  }

  /**
   * 设置扫码镜头放大比例
   * @param zoom
   */
  setZoom(zoom: number) {
    try {
      customScan.setZoom(zoom)
    } catch (e) {
      console.warn(e)
    }
  }

  /**
   * 获取扫码镜头放大比例
   */
  getZoom(): number {
    try {
      return customScan.getZoom()
    } catch (e) {
      console.warn(e)
      return 0
    }
  }

  /**
   * 获取闪光灯开启状态
   * @returns
   */
  getLightStatus(): boolean {
    try {
      return customScan.getFlashLightStatus()
    } catch (e) {
      console.warn(e)
      return false
    }
  }

  /**
   * 启动扫码
   */
  startScan() {
    this.scanLineY = this.scannerSize
    if (this.isLoaded) {
      if (this.viewControl != undefined) {
        this.checkPermissionAndInitCamera()
      }
    } else {
      this.releaseScan();
    }
  }

  /**
   * 扫描网络url
   * @param url
   */
  scanUrl(url: string, options: scanBarcode.ScanOptions = {
    scanTypes: this.scanTypes,
    enableMultiMode: true,
    enableAlbum: true
  }) {
    const res = ScanUtil.scanUrl(url, options)
    this.scanPromiseHandler(res)
  }

  /**
   * 扫描图片PixelMap
   * @param pixelMap
   */
  scanPixelMap(pixelMap: PixelMap, options: scanBarcode.ScanOptions = {
    scanTypes: this.scanTypes,
    enableMultiMode: true,
    enableAlbum: true
  }) {
    const res = ScanUtil.scanPixelMap(pixelMap, options)
    this.scanPromiseHandler(res)
  }

  /**
   * 扫描uri
   * @param uri
   * @param options
   */
  scanUri(uri: string, options: scanBarcode.ScanOptions = {
    scanTypes: this.scanTypes,
    enableMultiMode: true,
    enableAlbum: true
  }) {
    const res = ScanUtil.scanUri(uri, options)
    this.scanPromiseHandler(res)
  }

  /**
   * 处理扫码之后的promise
   * @param promise
   */
  private scanPromiseHandler(promise: Promise<string>) {
    promise.then((res) => {
      this.onScanResult?.(ResultState.Success, res);
    }).catch((err: string) => {
      this.onScanResult?.(ResultState.Fail, err);
    })
  }

  /**
   * 判断二维码是否在扫码框内
   * @param left
   * @param top
   * @param right
   * @param bottom
   * @returns
   */
  private isInScanRect(left: number, top: number, right: number, bottom: number): boolean {
    if ((left > this.scanRectLeftBoundary - this.areaOffset)
      && (top > this.scanRectTopBoundary - this.areaOffset)
      && (right < this.scanRectRightBoundary + this.areaOffset)
      && (bottom < this.scanRectBottomBoundary + this.areaOffset)) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * 重启相机扫码
   */
  rescan() {
    setTimeout(() => {
      if (!this.isRelease) {
        try {
          customScan.stop().then(() => {
            customScan.start(this.viewControl, this.callback);
          }).catch(() => {
            customScan.start(this.viewControl, this.callback);
          })
          this.isRelease = false
        } catch (e) {
          console.warn(e)
        }
      }
    }, this.scanIntervalTime)
  }

  /**
   * 检查相机权限打开相机
   */
  checkPermissionAndInitCamera() {
    requestPermissionsFromUser(getContext(this) as common.UIAbilityContext, 'ohos.permission.CAMERA')
      .then(() => {
        this.onCameraGrant?.()
        if (canIUse('SystemCapability.Multimedia.Scan.Core')) {
          let options: scanBarcode.ScanOptions = {
            scanTypes: this.scanTypes,
            enableMultiMode: false,
            enableAlbum: true
          };
          try {
            //初始化相机
            customScan.init(options)
            //打开相机
            customScan.start(this.viewControl, this.callback);
            this.isRelease = false
          } catch (e) {
            console.warn(e)
          }
        } else {
          console.warn('不支持扫码');
          return
        }
      }).catch(() => {
      this.onCameraReject?.()
      console.warn('初始化相机异常');
    })
  }

  /**
   * 释放相机资源
   */
  releaseScan() {
    this.isRelease = true
    try {
      if (canIUse('SystemCapability.Multimedia.Scan.Core')) {
        customScan.stop().then(() => {
          console.log('相机停止成功')
        }).catch((error: BusinessError) => {
          console.warn(`停止失败, code: ${error.code}, message: ${error.message}`)
        });

        customScan.release().then(() => {
          console.log('相机释放成功')
        }).catch((error: BusinessError) => {
          console.warn(`相机释放失败, code: ${error.code}, message: ${error.message}`)
        })
      } else {
        console.warn('不支持扫码');
        return
      }
    } catch (e) {
      console.warn(e)
    }
  }

  /**
   * 启动视频帧分析
   */
  private startAnalyzer() {
    if (!this.luminanceAnalyzerId) {
      this.luminanceAnalyzerId = setInterval(() => {
        image.createPixelMapFromSurface(this.surfaceId, { x: 0, y: 0, size: { height: this.defaultHeight, width: this.defaultHeight } }).then((pixmap) => {
          calculateLuminance(pixmap).then((percent) => {
            this.luminanceListener?.(percent)
          })
        })
      }, this.luminanceAnalyzerInterval)
    }
  }

  build() {
    Stack() {
      this.Camera()
      this.Mask()
      this.ScannerLayout()
      this.ButtonLayout()
    }.backgroundColor(Color.Black)
    .onSizeChange((_, value) => {
      this.screenWidth = value.width as number
      this.screenHeight = value.height as number
    })
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && (currentRatio >= 1.0 || (currentRatio > 0.9 && this.safeAreaType &&
        this.safeAreaType?.length > 0 && this.safeAreaEdge && this.safeAreaEdge.length > 0))) {
        if (!this.firstShow) {
          this.startScan()
        }
        this.firstShow = false
        if (this.luminanceListener) {
          this.startAnalyzer()
        }
      }
      if (!isVisible && currentRatio <= 0) {
        this.releaseScan()
        if (this.luminanceAnalyzerId) {
          clearInterval(this.luminanceAnalyzerId)
          this.luminanceAnalyzerId = 0
        }
      }
    })
    .expandSafeArea(this.safeAreaType, this.safeAreaEdge)
  }

  /**
   * 功能按钮
   */
  @Builder
  ButtonLayout() {
    Column() {
      Row() {
        Column() {
          Image(this.albumsIcon)
            .height(this.albumsIconSize)
            .width(this.albumsIconSize)

          Text(this.albumsText)
            .fontSize(this.albumsTextSize)
            .fontColor(this.albumsTextColor)
            .margin({ top: 4, bottom: 10 })
        }.visibility(this.albumsShow ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.pickPhoto()
        })

        if (this.albumsShow && this.lightShow) {
          Divider()
            .vertical(true)
            .strokeWidth(10)
            .color(Color.Transparent)
            .width(81)
            .height(this.albumsIconSize)
        }

        Column() {
          Image(this.isLightOpen ? this.lightOpenIcon : this.lightCloseIcon)
            .height(this.lightIconSize)
            .width(this.lightIconSize)

          Text(this.isLightOpen ? this.lightOpenText : this.lightCloseText)
            .fontSize(this.lightTextSize)
            .fontColor(this.lightTextColor)
            .margin({ top: 4, bottom: 10 })
        }.visibility(this.lightShow ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.toggleLight()
        })

      }.margin({ bottom: 20 })

    }.height('100%')
    .width('100%')
    .justifyContent(FlexAlign.End)
    .hitTestBehavior(HitTestMode.Transparent)
  }

  /**
   * 扫码布局
   */
  @Builder
  ScannerLayout() {
    Column() {
      this.Scanner()

      Text(this.tips)
        .fontColor(this.tipsTextColor)
        .fontSize(this.tipsTextSize)
        .visibility(this.tipsShow ? Visibility.Visible : Visibility.None)
        .margin({ top: this.tipsTopMargin })
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
  }

  /**
   * 扫码窗口
   */
  @Builder
  Scanner() {
    RelativeContainer() {

      ScanTopLeftRect({
        cornerLineWidth: this.cornerLineWidth,
        cornerLineLength: this.cornerLineLength,
        cornerLineColor: this.cornerLineColor
      }).alignRules({
        top: { anchor: 'topRect', align: VerticalAlign.Bottom },
        left: { anchor: 'leftRect', align: HorizontalAlign.End }
      }).id('scanTopLeftRect')
        .visibility(this.cornerLineShow ? Visibility.Visible : Visibility.None)

      ScanTopRightRect({
        cornerLineWidth: this.cornerLineWidth,
        cornerLineLength: this.cornerLineLength,
        cornerLineColor: this.cornerLineColor
      }).alignRules({
        top: { anchor: 'topRect', align: VerticalAlign.Bottom },
        right: { anchor: 'rightRect', align: HorizontalAlign.Start }
      }).id('scanTopRightRect')
        .alignRules({
          top: {
            anchor: '__container__',
            align: VerticalAlign.Top
          },
          right: {
            anchor: '__container__',
            align: HorizontalAlign.End
          }
        })
        .visibility(this.cornerLineShow ? Visibility.Visible : Visibility.None)

      ScanBottomLeftRect({
        cornerLineWidth: this.cornerLineWidth,
        cornerLineLength: this.cornerLineLength,
        cornerLineColor: this.cornerLineColor
      }).alignRules({
        bottom: { anchor: 'bottomRect', align: VerticalAlign.Top },
        left: { anchor: 'leftRect', align: HorizontalAlign.End }
      }).id('ScanBottomRightRect')
        .alignRules({
          bottom: {
            anchor: '__container__',
            align: VerticalAlign.Bottom
          },
          left: {
            anchor: '__container__',
            align: HorizontalAlign.Start
          }
        })
        .visibility(this.cornerLineShow ? Visibility.Visible : Visibility.None)

      ScanBottomRightRect({
        cornerLineWidth: this.cornerLineWidth,
        cornerLineLength: this.cornerLineLength,
        cornerLineColor: this.cornerLineColor
      }).alignRules({
        bottom: { anchor: 'bottomRect', align: VerticalAlign.Top },
        right: { anchor: 'rightRect', align: HorizontalAlign.Start }
      }).id('scanBottomRightRect')
        .alignRules({
          bottom: {
            anchor: '__container__',
            align: VerticalAlign.Bottom
          },
          right: {
            anchor: '__container__',
            align: HorizontalAlign.End
          }
        })
        .visibility(this.cornerLineShow ? Visibility.Visible : Visibility.None)


      Column() {
        if (this.scanLineShow) {
          Line()
            .width(this.scanLineLength)
            .height(this.scanLineWidth)
            .backgroundColor(this.scanLineColor)
            .alignRules({
              top: { anchor: 'topRect', align: VerticalAlign.Bottom },
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
            })
            .translate({ y: this.scanLineY })
            .animation({
              duration: this.scanAnimTime,
              iterations: -1, // 设置-1表示动画无限循环
              curve: Curve.Linear,
              playMode: PlayMode.Normal,
            })
        }
      }
      .width(this.scannerSize)
      .height(this.scannerSize)
      .visibility(this.scanLineY > 0 ? Visibility.Visible : Visibility.Hidden)
      .id("contain")
      .alignRules({
        center: {
          anchor: '__container__',
          align: VerticalAlign.Center
        },
        middle: {
          anchor: '__container__',
          align: HorizontalAlign.Center
        }
      })
    }
    .width(this.scannerSize + (this.cornerLineWidth * 2))
    .height(this.scannerSize + (this.cornerLineWidth * 2))
    .margin({ top: this.scanTopMargin })
  }

  @Builder
  Mask() {
    Column() {
      Row()
        .backgroundColor(this.maskColor)
        .width('100%')
        .height(this.scanTopMargin + this.cornerLineWidth)

      Row() {
        Row()
          .backgroundColor(this.maskColor)
          .width((this.screenWidth - this.scannerSize) / 2)
          .height(Math.min(this.scannerSize, this.screenHeight - (this.scanTopMargin + this.cornerLineWidth)))

        Row()
          .backgroundColor(this.maskColor)
          .width((this.screenWidth - this.scannerSize) / 2)
          .height(Math.min(this.scannerSize, this.screenHeight - (this.scanTopMargin + this.cornerLineWidth)))
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row()
        .backgroundColor(this.maskColor)
        .width('100%')
        .layoutWeight(1)
    }
    .hitTestBehavior(HitTestMode.Transparent)
    .width(this.screenWidth)
    .height(this.screenHeight)
    .position({ x: 0, y: 0 })
  }

  /**
   * 相机图像
   */
  @Builder
  Camera() {
    XComponent({
      id: 'componentId',
      type: XComponentType.SURFACE,
      controller: this.mXComponentController
    })
      .onLoad(() => {
        // 获取XComponent的surfaceId
        this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
        this.mXComponentController.setXComponentSurfaceRect({
          surfaceWidth: display.getDefaultDisplaySync().width,
          surfaceHeight: display.getDefaultDisplaySync().height
        })
        // 设置ViewControl相应字段
        this.viewControl = {
          width: this.screenWidth,
          height: this.screenHeight,
          surfaceId: this.surfaceId
        }
        this.isLoaded = true
        this.startScan()
      })
      .backgroundColor(Color.Transparent)
      .width(this.screenWidth)
      .height(this.screenHeight)
      .position({ x: 0, y: 0 })
      .gesture(PinchGesture().onActionUpdate((event) => {
        if (this.isLoaded) {
          try {
            customScan.setZoom(customScan.getZoom() * event.scale)
          } catch (e) {
            console.warn(e)
          }
        }
      }))
  }
}

export class ScannerController implements ScannerControllerInterface {
  private scanner: Scanner | undefined

  init(scanner: Scanner) {
    this.scanner = scanner
  }

  openLight() {
    this.scanner?.openLight()
  }

  closeLight() {
    this.scanner?.closeLight()
  }

  toggleLight() {
    this.scanner?.toggleLight()
  }

  pickPhoto() {
    this.scanner?.pickPhoto()
  }

  setZoom(zoom: number) {
    this.scanner?.setZoom(zoom)
  }

  getZoom(): number {
    return this.scanner?.getZoom() ?? 0
  }

  getLightStatus(): boolean {
    return this.scanner?.getLightStatus() ?? false
  }

  releaseScan() {
    this.scanner?.releaseScan()
  }

  startScan() {
    this.scanner?.startScan()
  }

  rescan() {
    this.scanner?.rescan()
  }

  scanUri(uri: string) {
    this.scanner?.scanUri(uri)
  }

  scanUrl(url: string) {
    this.scanner?.scanUrl(url)
  }

  scanPixelMap(pixelMap: PixelMap) {
    this.scanner?.scanPixelMap(pixelMap)
  }
}