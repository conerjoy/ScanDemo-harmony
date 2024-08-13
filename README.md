## 鸿蒙扫一扫组件

***

- 利用鸿蒙系统customScan能力
- 支持选择图库扫码能力
- 支持开启关闭闪光灯
- 支持UI定制
- 手指撑开缩小控制镜头缩放倍数

![截屏](https://communityfile-drcn.op.hicloud.com/FileServer/getFile/cmtybbstemp/20240807/cmtybbs/752/372/949/0030086000752372949.20240807215416.41746396059467540421985835464896:20240807225417:2800:449C75883C1493F039B0F5E815B273804661C1DAE792D282CEBC4C564DBB8337.jpg)

使用示例<br>

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

## 安装使用

***

```json
ohpm i @coner/scanner
```

## Scanner 属性

***

|       字段名        |                     类型                     |                 默认值                 |      说明      |
|:----------------:|:------------------------------------------:|:-----------------------------------:|:------------:|
|    albumsShow    |                  boolean                   |                true                 |    相册是否显示    |
|    albumsIcon    |                ResourceStr                 |   $r('app.media.scanner_albums')    |     相册图标     |
|  albumsIconSize  |                   Length                   |                 64                  |    相册图标大小    |
|    albumsText    |                   string                   |                '相册'                 |     相册文案     |
|  albumsTextSize  |                   Length                   |                 16                  |   相册文案文字大小   |
| albumsTextColor  |               ResourceColor                |             Color.White             |    相册文案颜色    |
|    lightShow     |                  boolean                   |                true                 |   手电筒是否显示    |
|  lightCloseIcon  |                ResourceStr                 | $r('app.media.scanner_light_close') |   手电筒关闭图标    |
|  lightOpenIcon   |                ResourceStr                 | $r('app.media.scanner_light_open')  |   手电筒开启图标    |
|  lightIconSize   |                   Length                   |                 64                  |   手电筒图标大小    |
|  lightOpenText   |                   string                   |                '开灯'                 |   手电筒开启文案    |
|  lightCloseText  |                   string                   |                '关灯'                 |   手电筒关闭文案    |
|  lightTextSize   |                   Length                   |                 16                  |   手电筒文字大小    |
|  lightTextColor  |               ResourceColor                |             Color.White             |   手电筒文案颜色    |
|     tipsShow     |                  boolean                   |                true                 |   提示词是否显示    |
|       tips       |                   string                   |        '将条码、二维码放入框内，即可自动扫描'         |    提示词内容     |
|  tipsTextColor   |               ResourceColor                |             Color.White             |   提示词文字颜色    |
|   tipsTextSize   |                   Length                   |                 14                  |   提示词文字大小    |
|  tipsTopMargin   |                   Length                   |                 10                  |  提示词距离上面的间距  |
|    maskColor     |               ResourceColor                |             '#7f000000'             |     遮罩颜色     |
|   scannerSize    |                   number                   |                 256                 |    扫描框宽高     |
| cornerLineWidth  |                   number                   |                  3                  |    角上的框宽度    |
| cornerLineLength |                   number                   |                 30                  |    角上的框长度    |
| cornerLineColor  |               ResourceColor                |             Color.White             |    角上的框颜色    |
|  cornerLineShow  |                  boolean                   |                true                 |   四个角是否显示    |
|  scanTopMargin   |                   number                   |                 100                 |  扫描框距离上面的间距  |
|  scanLineWidth   |                   Length                   |                  1                  |    扫描线宽度     |
|  scanLineLength  |                   Length                   |               '100%'                |    扫描线长度     |
|  scanLineColor   |               ResourceColor                |             Color.White             |    扫描线颜色     |
|   scanLineShow   |                  boolean                   |                true                 |   扫描线是否显示    |
|   scanAnimTime   |                   number                   |                1500                 |     动画时间     |
| scanIntervalTime |                   number                   |                1000                 |    扫码间隔时间    |
| disableCheckArea |                  boolean                   |                false                | 是否禁止检查二维码在框中 |
|    areaOffset    |                   number                   |                 100                 |  二维码在框中的偏移量  |
|    controller    |             ScannerController              |       this.scannerController        |    扫码控制类     |
|   onScanResult   | (code: ResultState, value: string) => void |              undefined              |   扫码结果回调函数   |
|  onCameraGrant   |                 () => void                 |              undefined              |  摄像头权限同意回调   |
|  onCameraReject  |                 () => void                 |              undefined              |  摄像头权限拒绝回调   |

## ScannerController 方法

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

## ScanUtil

- 在非扫码页面（未使用Scanner组件）时调用扫描网络图片、图片uri、图片PixelMap能力

|      方法      |         入参         |       返回值       |      说明      |
|:------------:|:------------------:|:---------------:|:------------:|
|   scanUri    |    uri: string     | Promise<string> |  扫描图片资源uri   |
|   scanUrl    |    url: string     | Promise<string> |  扫描网络图片url   |
| scanPixelMap | pixelMap: PixelMap | Promise<string> | 扫描图片PixelMap |

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


## 自定义UI

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


## 交流催更

QQ君羊: 571144615

![qq群](https://communityfile-drcn.op.hicloud.com/FileServer/getFile/cmtybbstemp/20240807/cmtybbs/752/372/949/0030086000752372949.20240807215423.49520007517393891101454977556817:20240807225423:2800:0C84955B1E6A66D85941A39F69CA7BFF669BACE5249CF688D6176C5BB49CB6E8.jpg)

## 感谢支持