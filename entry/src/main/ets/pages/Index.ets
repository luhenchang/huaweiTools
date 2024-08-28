// 使用方自定义AttributeModifier接口实现类，此处指定泛型为Button组件的属性类ButtonAttribute
import { common, OpenLinkOptions, Want } from '@kit.AbilityKit';
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppUtil } from '../AppUtil';
import { DeepAppLinkUtil } from '../DeepAppLinkUtil';
import { http } from '@kit.NetworkKit';
import { promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';

import { abilityAccessCtrl, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { ImageCacheUtil } from '../ImageCacheUtil';

const TAG: string = '[Permission]';
const PERMISSIONS: Array<Permissions> = ["ohos.permission.READ_IMAGEVIDEO", "ohos.permission.WRITE_IMAGEVIDEO"];
const context = getContext(this) as common.UIAbilityContext;

export default async function grantPermission(): Promise<boolean> {
  try {
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    let tokenId = appInfo.accessTokenId;
    let atManager = abilityAccessCtrl.createAtManager();
    let pems: Array<Permissions> = [];
    for (let i = 0; i < PERMISSIONS.length; i++) {
      let state = await atManager.checkAccessToken(tokenId, PERMISSIONS[i]);
      if (state !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        pems.push(PERMISSIONS[i]);
      }
    }
    if (pems.length > 0) {
      let ctx = context
      let result: PermissionRequestResult = await atManager.requestPermissionsFromUser(ctx, pems);
      let grantStatus: Array<number> = result.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] !== 0) {
          return false;
        }
      }
    }
    return true;
  } catch (error) {
    return false;
  }
}


//使用方使用提供方的公用组件MyButton
@Entry
@Component
struct Index {
  @State image: image.PixelMap | undefined = undefined;
  @State imageLocal: image.PixelMap | string | undefined = undefined;

  async aboutToAppear(): Promise<void> {
    this.imageLocal = await ImageCacheUtil.downLoadCacheFile(getContext(),
      'https://photo.16pic.com/00/82/08/16pic_8208987_b.jpg')
  }

  build() {
    Column() {
      if (this.imageLocal != undefined) {
        Image(this.imageLocal)
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%').onClick(async () => {
      //this.downLoad()
      await ImageCacheUtil.clearImageCache()
      //https://www.baidu.com/img/flexible/logo/pc/result@2.png
      //https://p3-passport.byteacctimg.com/img/user-avatar/0eeb7cf052adc130878c997df2233fa5~180x180.awebp
      //https://img10.360buyimg.com/img/jfs/t1/176863/16/41608/14330/668e3421F64b41094/15c9d9130b980a51.png
      //https://www.zhipin.com/sem/static/img/banner.97f904e9.png
      //https://img1.baidu.com/it/u=3809505498,1140154284&fm=253&fmt=auto&app=138&f=JPEG?w=641&h=500
      //https://img.zcool.cn/community/010ddd6034cd9e11013ef90fe189f7.gif
      //https://5b0988e595225.cdn.sohucs.com/q_70,c_zoom,w_640/images/20190514/eca8cb6ea55c42e2a1adec000b95e678.gif
      //https://img0.baidu.com/it/u=143672386,1614197866&fm=253&fmt=auto&app=138&f=JPEG?w=300&h=300


      //DeepAppLinkUtil.jumpByLinkOfOpenLink('jumpScheme://www.jump.com:8080/ansp/path')
      // DeepAppLinkUtil.checkCanOpenLink('jumpScheme://www.jump.com:8080')
      // DeepAppLinkUtil.jumpApp('C5765880207853008087', 'jumpSchemes://www.jump.com:8080/ansp/path')
    })
  }
}