## 鸿蒙扫一扫组件（多码识别）

***

- 利用鸿蒙系统customScan能力，实现二维码识别
- 支持多码识别
- 支持选择图库扫码能力
- 支持开启关闭闪光灯
- 支持UI定制
- 手指撑开缩小控制镜头缩放倍数

![截屏](https://communityfile-drcn.op.hicloud.com/FileServer/getFile/cmtybbstemp/20240807/cmtybbs/752/372/949/0030086000752372949.20240807215416.41746396059467540421985835464896:20240807225417:2800:449C75883C1493F039B0F5E815B273804661C1DAE792D282CEBC4C564DBB8337.jpg)

使用示例<br>

### 单码识别

- 导入

```typescript
import { Scanner, ScannerController } from '@coner/Scanner';
```

- 使用

```typescript
scannerController: ScannerController = new ScannerController()
```

```typescript
Scanner({
  controller: this.scannerController,
  onScanResult: (code: ResultState, value: string) => {
    if (code == ResultState.Success) {
      promptAction.showToast({ message: value })
    }
  },
  onCameraReject: () => {
    promptAction.showToast({ message: '摄像头权限被拒绝' })
  }
}).layoutWeight(1)
```

### 多码识别

- 导入

```typescript
import { ProScanner, ProScannerController } from '@ohos/Scanner'
```

- 使用

```typescript
controller: ProScannerController = new ProScannerController()
```

```typescript
ProScanner({
  controller: this.controller,
  onFindMultipleCode: (result: scanBarcode.ScanResult[]) => {
    promptAction.showToast({ message: '发现了' + result.length + '个二维码' })
  },
  onScanResult: (code: ResultState, value: string) => {
    if (code == ResultState.Success) {
      promptAction.showToast({ message: value })
    }
  }
})
  .layoutWeight(1)
```

## 安装使用

***

```json
ohpm i @coner/scanner
```

## Scanner 属性

***

|            字段名            |                     类型                     |                 默认值                 |         说明          |
|:-------------------------:|:------------------------------------------:|:-----------------------------------:|:-------------------:|
|        albumsShow         |                  boolean                   |                true                 |       相册是否显示        |
|        albumsIcon         |                ResourceStr                 |   $r('app.media.scanner_albums')    |        相册图标         |
|      albumsIconSize       |                   Length                   |                 64                  |       相册图标大小        |
|        albumsText         |                   string                   |                '相册'                 |        相册文案         |
|      albumsTextSize       |                   Length                   |                 16                  |      相册文案文字大小       |
|      albumsTextColor      |               ResourceColor                |             Color.White             |       相册文案颜色        |
|         lightShow         |                  boolean                   |                true                 |       手电筒是否显示       |
|      lightCloseIcon       |                ResourceStr                 | $r('app.media.scanner_light_close') |       手电筒关闭图标       |
|       lightOpenIcon       |                ResourceStr                 | $r('app.media.scanner_light_open')  |       手电筒开启图标       |
|       lightIconSize       |                   Length                   |                 64                  |       手电筒图标大小       |
|       lightOpenText       |                   string                   |                '开灯'                 |       手电筒开启文案       |
|      lightCloseText       |                   string                   |                '关灯'                 |       手电筒关闭文案       |
|       lightTextSize       |                   Length                   |                 16                  |       手电筒文字大小       |
|      lightTextColor       |               ResourceColor                |             Color.White             |       手电筒文案颜色       |
|         tipsShow          |                  boolean                   |                true                 |       提示词是否显示       |
|           tips            |                   string                   |        '将条码、二维码放入框内，即可自动扫描'         |        提示词内容        |
|       tipsTextColor       |               ResourceColor                |             Color.White             |       提示词文字颜色       |
|       tipsTextSize        |                   Length                   |                 14                  |       提示词文字大小       |
|       tipsTopMargin       |                   Length                   |                 10                  |     提示词距离上面的间距      |
|         maskColor         |               ResourceColor                |             '#7f000000'             |        遮罩颜色         |
|        scannerSize        |                   number                   |                 256                 |        扫描框宽高        |
|      cornerLineWidth      |                   number                   |                  3                  |       角上的框宽度        |
|     cornerLineLength      |                   number                   |                 30                  |       角上的框长度        |
|      cornerLineColor      |               ResourceColor                |             Color.White             |       角上的框颜色        |
|      cornerLineShow       |                  boolean                   |                true                 |       四个角是否显示       |
|       scanTopMargin       |                   number                   |                 100                 |     扫描框距离上面的间距      |
|       scanLineWidth       |                   Length                   |                  1                  |        扫描线宽度        |
|      scanLineLength       |                   Length                   |               '100%'                |        扫描线长度        |
|       scanLineColor       |               ResourceColor                |             Color.White             |        扫描线颜色        |
|       scanLineShow        |                  boolean                   |                true                 |       扫描线是否显示       |
|       scanAnimTime        |                   number                   |                1500                 |        动画时间         |
|     scanIntervalTime      |                   number                   |                1000                 |       扫码间隔时间        |
|     disableCheckArea      |                  boolean                   |                false                |    是否禁止检查二维码在框中     |
|        areaOffset         |                   number                   |                 100                 |     二维码在框中的偏移量      |
|         onceScan          |                  boolean                   |                true                 | 是否单次扫描（单次扫描后应该关闭页面） |
|         scanTypes         |          Array<scanCore.ScanType>          |       [scanCore.ScanType.ALL]       |        扫描类型         |
|       safeAreaType        |            Array<SafeAreaType>             |        [SafeAreaType.SYSTEM]        |     配置扩展安全区域的类型     |
|       safeAreaEdge        |            Array<SafeAreaEdge>             |        [SafeAreaEdge.BOTTOM]        |     配置扩展安全区域的方向     |
| luminanceAnalyzerInterval |                   number                   |                1000                 |   亮度检测时间间（单位：ms）    |
|     luminanceListener     |        (luminance: number) => void         |              undefined              | 亮度检测监听（添加监听则开启亮度检测） |
|        controller         |             ScannerController              |       this.scannerController        |        扫码控制类        |
|       onScanResult        | (code: ResultState, value: string) => void |              undefined              |      扫码结果回调函数       |
|       onCameraGrant       |                 () => void                 |              undefined              |      摄像头权限同意回调      |
|      onCameraReject       |                 () => void                 |              undefined              |      摄像头权限拒绝回调      |

### ScannerController控制器

***

|       方法       |         入参         |   返回值   |      说明      |
|:--------------:|:------------------:|:-------:|:------------:|
|   openLight    |        void        |  void   |    打开闪光灯     |
|   closeLight   |        void        |  void   |    关闭闪光灯     |
|  toggleLight   |        void        |  void   |    闪光点开关     |
|   pickPhoto    |        void        |  void   |  选择图片识别二维码   |
|    setZoom     |    zoom: number    |  void   |  设置扫码镜头放大比例  |
|    getZoom     |        void        | number  |  获取扫码镜头放大比例  |
| getLightStatus |        void        | boolean |  获取闪光灯开启状态   |
|  releaseScan   |        void        |  void   |    释放相机资源    |
|   startScan    |        void        |  void   |     启动扫码     |
|     rescan     |        void        |  void   |    重启相机扫码    |
|    scanUri     |    uri: string     |  void   |  扫描图片资源uri   |
|    scanUrl     |    url: string     |  void   |  扫描网络图片url   |
|  scanPixelMap  | pixelMap: PixelMap |  void   | 扫描图片PixelMap |

### 使用方法

```typescript
this.scannerController.scanUrl(url) // 扫码结果回调到Scanner组件的onScanResult回调方法
```

## ProScanner 属性-多码识别

***

|            字段名            |                     类型                     |                 默认值                 |         说明          |
|:-------------------------:|:------------------------------------------:|:-----------------------------------:|:-------------------:|
|        albumsShow         |                  boolean                   |                true                 |       相册是否显示        |
|        albumsIcon         |                ResourceStr                 |   $r('app.media.scanner_albums')    |        相册图标         |
|      albumsIconSize       |                   Length                   |                 64                  |       相册图标大小        |
|        albumsText         |                   string                   |                '相册'                 |        相册文案         |
|      albumsTextSize       |                   Length                   |                 16                  |      相册文案文字大小       |
|      albumsTextColor      |               ResourceColor                |             Color.White             |       相册文案颜色        |
|         lightShow         |                  boolean                   |                true                 |       手电筒是否显示       |
|      lightCloseIcon       |                ResourceStr                 | $r('app.media.scanner_light_close') |       手电筒关闭图标       |
|       lightOpenIcon       |                ResourceStr                 | $r('app.media.scanner_light_open')  |       手电筒开启图标       |
|       lightIconSize       |                   Length                   |                 64                  |       手电筒图标大小       |
|       lightOpenText       |                   string                   |                '开灯'                 |       手电筒开启文案       |
|      lightCloseText       |                   string                   |                '关灯'                 |       手电筒关闭文案       |
|       lightTextSize       |                   Length                   |                 16                  |       手电筒文字大小       |
|      lightTextColor       |               ResourceColor                |             Color.White             |       手电筒文案颜色       |
|     scanIntervalTime      |                   number                   |                1000                 |       扫码间隔时间        |
|       pointViewSize       |                   number                   |                 40                  |       多码标志点大小       |
|      pointViewColor       |               ResourceColor                |              '#4AA4F9'              |       多码标志点颜色       |
|   pointViewBorderWidth    |                   number                   |                  3                  |      多码标志点边框宽度      |
|         pointIcon         |                ResourceStr                 | $r('app.media.scanner_arrow_right') |       多码标志点图片       |
|       pointIconSize       |                   number                   |                 26                  |      多码标志点图片大小      |
|   pointViewBorderColor    |               ResourceColor                |             Color.White             |      多码标志点边框颜色      |
|    pointViewLeftOffset    |                   number                   |                 20                  |     多码标志点向左的偏移量     |
|    pointViewTopOffset     |                   number                   |                 20                  |     多码标志点向上的偏移量     |
|         pointView         |               CustomBuilder                |               组件默认样式                |     多码标志点自定义UI      |
|         onceScan          |                  boolean                   |                true                 | 是否单次扫描（单次扫描后应该关闭页面） |
|         scanTypes         |          Array<scanCore.ScanType>          |       [scanCore.ScanType.ALL]       |        扫描类型         |
|       safeAreaType        |            Array<SafeAreaType>             |        [SafeAreaType.SYSTEM]        |     配置扩展安全区域的类型     |
|       safeAreaEdge        |            Array<SafeAreaEdge>             |        [SafeAreaEdge.BOTTOM]        |     配置扩展安全区域的方向     |
| luminanceAnalyzerInterval |                   number                   |                1000                 |   亮度检测时间间（单位：ms）    |
|     luminanceListener     |        (luminance: number) => void         |              undefined              | 亮度检测监听（添加监听则开启亮度检测） |
|        controller         |            ProScannerController            |       this.scannerController        |        扫码控制类        |
|    onFindMultipleCode     | (result: scanBarcode.ScanResult[]) => void |              undefined              |      发现多码回调函数       |
|       onScanResult        | (code: ResultState, value: string) => void |              undefined              |      扫码结果回调函数       |
|       onCameraGrant       |                 () => void                 |              undefined              |      摄像头权限同意回调      |
|      onCameraReject       |                 () => void                 |              undefined              |      摄像头权限拒绝回调      |

### ProScannerController控制器

与ScannerController一致，此处省略

## ScanUtil

***

- 在非扫码页面（未使用Scanner组件）时调用扫描网络图片、图片uri、图片PixelMap能力

|      方法      |                     入参                     |       返回值       |      说明      |
|:------------:|:------------------------------------------:|:---------------:|:------------:|
|   scanUri    |    uri: string,scanBarcode.ScanOptions     | Promise<string> |  扫描图片资源uri   |
|   scanUrl    |    url: string,scanBarcode.ScanOptions     | Promise<string> |  扫描网络图片url   |
| scanPixelMap | pixelMap: PixelMap,scanBarcode.ScanOptions | Promise<string> | 扫描图片PixelMap |

### 使用方法

```typescript
ScanUtil.scanUrl(url)
  .then((res) => {
    promptAction.showToast({ message: res })
  })
  .catch((err: string) => {
    promptAction.showToast({ message: '失败了：' + err })
  })
```

## 声明权限

entry module下的module.json5中新增如下配置

```typescript
{
  "module": {
    // ...
    'requestPermissions': [
      {
        "name": "ohos.permission.INTERNET",
      },{
        "name": "ohos.permission.CAMERA",
        "reason": "$string:reasonRequestCamera",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      }
    ]
  }
}
```

## 单码识别自定义UI

***

```typescript
Scanner({
  cornerLineShow: false, // 隐藏四个角
  scanLineShow: false, // 隐藏扫描线
  albumsShow: false, // 隐藏图库按钮和文字
  lightShow: false, // 隐藏闪光点按钮和文字
  tipsShow: false, // 隐藏提示词
  maskColor: Color.Transparent, // 蒙层透明
  onScanResult: (code: ResultState, value: string) => {
    if (code == ResultState.Success) {
      promptAction.showToast({ message: value })
    }
  },
  onCameraReject: () => {
    promptAction.showToast({ message: '摄像头权限被拒绝' })
  }
})
```

## 多码识别自定义UI

***
调整默认的多码标志点UI

```typescript
ProScanner({
  pointViewSize: 40,
  pointViewColor: '#4AA4F9',
  pointViewBorderWidth: 3,
  pointIcon: $r('app.media.xxxxx'),
  pointIconSize: 26,
  pointViewBorderColor: Color.White,
  pointViewLeftOffset: 20,
  pointViewTopOffset: 20,
})
```

对默认样式不满意可以直接重写标志点UI

```typescript
ProScanner({
  pointView: this.PointView()
})
```

```typescript
@Builder
PointView() {
  // 自定义UI样式
}
```

## 交流催更

QQ君羊: 571144615

![qq群](https://communityfile-drcn.op.hicloud.com/FileServer/getFile/cmtybbstemp/20240807/cmtybbs/752/372/949/0030086000752372949.20240807215423.49520007517393891101454977556817:20240807225423:2800:0C84955B1E6A66D85941A39F69CA7BFF669BACE5249CF688D6176C5BB49CB6E8.jpg)

## 感谢支持