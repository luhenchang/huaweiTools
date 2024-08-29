import { bundleManager, common, OpenLinkOptions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

//功能：应用跳转是指从一个应用跳转至另外一个应用，传递相应的数据、执行特定的功能。
//官方文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/deep-linking-startup-V5

export class DeepAppLinkUtil {
  //华为应用商店-应用详情链接
  private static storeUrl = 'store://appgallery.huawei.com/app/detail'
  private static TAG: string = this.name;

  /**
   * Deep Linking 方式
   * 目的：用户可跳转到对应应用的应用市场详情
   * appId：开发者可以在日志中获取appId
   * 获取方式：手机usb链接studio,确保日志窗口可以看到日志，
   * 打开华为应用市场。搜索选择想要获取的应用，并打开下载详情页，
   * 在日志窗口搜索："appid":查找到 C57 开头的字符串就是 => "C57658..."
   *
   * 测试 appId如下：
   * 支付宝：C5765880207853300119
   * 凤凰新闻:C5765880207853254515
   * 酷狗音乐：C5765880207853008087
   * @param appId
   * @returns
   */
  static jumpToMarket(appId: string) {
    if (appId.length <= 0) {
      console.warn(DeepAppLinkUtil.TAG, '::jumpToMarket  The appId  is Empty')
      return Promise.reject('param appId is Empty ')
    }
    const want: Want = {
      uri: `${DeepAppLinkUtil.storeUrl}?id=${appId}`
    };
    const context = getContext() as common.UIAbilityContext
    return context.startAbility(want)
  }

  /**
   * Deep Linking 方式
   * 目的：仅通过 uri 进行跳转到系统安装的目标 App。
   * 条件：需要知道被拉起应用设置的 link
   *      Want无 type,parameters等条件
   * 被拉起应用配置：
   * skills": [
   *           {"uris": [
   *                     {"scheme": "jumpScheme",
   *                      "host": "www.jump.com",
   *                      "port": '8080',
   *                      "path": "ansp/path"
   *                     }
   *                   ]
   *           }
   *         ]
   * 测试端: linkUrl = jumpScheme://www.jump.com:8080/ansp/path
   * @param linkUrl
   * @returns
   */
  static jumpByUriOfStartAbility(linkUrl: string) {
    if (linkUrl.length <= 0) {
      console.warn(DeepAppLinkUtil.TAG, '::jumpOtherAppByUrl  The linkUrl  is Empty')
      return Promise.reject('linkUrl param is Empty ')
    }
    const want: Want = {
      uri: linkUrl
    }
    const context = getContext() as common.UIAbilityContext
    return context.startAbility(want)
  }

  /**
   * Deep Linking 方式
   * 目的：通过自定义 Want 进行跳转到系统安装的目标 App。
   * 条件：Want 需要和被拉起应用配置对应
   * skills": [
   *           {"uris": [
   *                     {"scheme": "jumpScheme",
   *                      "host": "www.jump.com",
   *                      "port": '8080',
   *                      "path": "ansp/path"
   *                     }
   *                   ]
   *           }
   *         ]
   * 测试端 want:
   *     const want: Want = {
   *                           uri: 'jumpScheme://www.jump.com:8080/ansp/path',
   *                           parameters:{
   *                           'routerUrl':'pages/RedPage'
   *                           }
   *                      }
   * @param linkUrl
   * @returns
   */
  static jumpByCustomWantStartAbility(want: Want): Promise<void> {
    const context = getContext() as common.UIAbilityContext
    return context.startAbility(want)
  }

  /**
   * Deep Linking 方式
   * 被拉起配置：
   * skills": [
   *           {"uris": [
   *                     {"scheme": "jumpScheme",
   *                      "host": "www.jump.com",
   *                      "port": '8080',
   *                      "path": "ansp/path"
   *                     }
   *                   ]
   *           }
   *         ]
   * 调用端 link：'jumpScheme://www.jump.com:8080/ansp/path'
   */
  static jumpByLinkOfOpenLink(link: string): Promise<void> {
    let context: common.UIAbilityContext = getContext() as common.UIAbilityContext
    let openLinkOptions: OpenLinkOptions = {
      appLinkingOnly: false
    }
    return context.openLink(link, openLinkOptions)
  }

  /**
   * App Linking方式
   * 被拉起应用需要在AGC控制台开通App Linking服务
   * appLinkingOnly:默认是true
   * true :  仅以App Linking的方式打开应用。将appLinkingOnly参数设为true，若有匹配的应用，
   *        则直接打开目标应用。若无App Linking匹配的应用，则抛异常给开发者进行处理。
   * false: 则为App Linking优先的方式打开应用。若有App Linking匹配的应用，则直接打开目标应用。
   *        若无App Linking匹配的应用，则尝试以Deep Linking的方式打开应用。
   * 官方文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/app-linking-startup-V5#section145763212066
   * 调用端：link = "https://www.example.com/programs?action=showall"
   */
  static jumpByLinkOfAppLinking(link: string, appLinkingOnly: boolean = true) {
    let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
    // 仅以App Linking的方式打开应用
    context.openLink(link, { appLinkingOnly: appLinkingOnly }).then(() => {
      console.info(DeepAppLinkUtil.TAG, '::jumpByLinkOfAppLinking open link success.')
    }).catch((error: BusinessError) => {
      console.error(DeepAppLinkUtil.TAG, `::jumpByLinkOfAppLinking openlink failed. error:${JSON.stringify(error)}`)
    });
  }

  /**
   * 判断应用是否可以被访问
   * 条件：在调用方 entry模块的module.json5文件中配置querySchemes属性，声明想要查询的URL scheme。
   *      配置如右边："querySchemes": ['jumpScheme']
   * 被拉起配置：
   * skills": [
   *           {"uris": [
   *                     {"scheme": "jumpScheme",
   *                      "host": "www.jump.com",
   *                      "port": '8080',
   *                      "path": "ansp/path"
   *                     }
   *                   ]
   *           }
   *         ]
   * 调用端 link：'jumpScheme://www.jump.com:8080/ansp/path'
   * @param link
   */
  static checkCanOpenLink(link: string): boolean {
    try {
      let canOpen = bundleManager.canOpenLink(link);
      console.info(DeepAppLinkUtil.TAG, 'canOpenLink successfully: %{public}s', JSON.stringify(canOpen));
      return true
    } catch (err) {
      let message = (err as BusinessError).message;
      console.error(DeepAppLinkUtil.TAG, 'canOpenLink failed: %{public}s', message);
      return false
    }
  }

  /**
   * 增加检测是否系统安装了被吊起应用。
   * 安装就跳转拉起，否则跳转到应用商店详情。
   * @param appId
   * @param link
   */
  static jumpApp(appId: string, link: string) {
    if (DeepAppLinkUtil.checkCanOpenLink(link)) {
      DeepAppLinkUtil.jumpByLinkOfOpenLink(link)
    } else {
      DeepAppLinkUtil.jumpToMarket(appId)
    }
  }
}