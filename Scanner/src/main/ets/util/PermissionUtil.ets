/**
 * @author 610965
 * @data 2024/8/5 17:20
 */
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager'
import { BusinessError } from '@kit.BasicServicesKit';

export function requestPermissionsFromUser(context: common.UIAbilityContext, ...permissions: Permissions[]): Promise<void> {
  return new Promise((resolve, reject) => {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
          resolve()
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          // context.startAbility({
          //   bundleName: 'com.example.xxx.settings',
          //   abilityName: 'com.example.xxx.settings.MainAbility',
          //   uri: 'application_info_entry', //application_settings application_info_entry
          //   parameters: {
          //     pushParams: context.abilityInfo.bundleName
          //   }
          // })
          reject()
        }
      }
      // 授权成功
    }).catch((err: BusinessError) => {
      console.warn(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
      reject()
    })
  })
}


export async function checkPermissions(permission: Permissions): Promise<void> {
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkPermissionGrant(permission)

  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
  } else {
    // 申请麦克风权限
  }
}


async function checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}
