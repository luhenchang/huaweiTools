import { image } from '@kit.ImageKit';
import { ImageCacheUtil } from '../utils/ImageCacheUtil';
import { CatchImage, images, pageData, PageRouter } from '../data/data';
import { ImageView } from './ImageView';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


@Entry
@Component
struct Index {
  build() {
    List() {
      ForEach(pageData, (data: PageRouter, index) => {
        ListItem() {
          Column() {
            Text(data.title)
              .fontSize(20)
              .borderRadius(10)
              .width('100%')
              .height(100)
              .alignSelf(ItemAlign.Center)
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .backgroundColor('#ff17e5cd')
              .shadow({ radius: 10, color: Color.Gray })
          }.width('100%').padding({ left: 18.3, right: 18.3, top: 18.3 }).onClick(() => {
            router.pushUrl({ url: data.routerName })
          })
        }
      })
    }.height('100%').width('100%')
  }
}


// Column() {
//   // if (this.imageLocal != undefined) {
//   //   Image(this.imageLocal)
//   // }
// }
// .justifyContent(FlexAlign.Center)
// .width('100%')
// .height('100%').onClick(async () => {
//   //this.downLoad()
//   //await ImageCacheUtil.clearImageCache()
//   //https://www.baidu.com/img/flexible/logo/pc/result@2.png
//   //https://p3-passport.byteacctimg.com/img/user-avatar/0eeb7cf052adc130878c997df2233fa5~180x180.awebp
//   //https://img10.360buyimg.com/img/jfs/t1/176863/16/41608/14330/668e3421F64b41094/15c9d9130b980a51.png
//   //https://www.zhipin.com/sem/static/img/banner.97f904e9.png
//   //https://img1.baidu.com/it/u=3809505498,1140154284&fm=253&fmt=auto&app=138&f=JPEG?w=641&h=500
//   //https://img.zcool.cn/community/010ddd6034cd9e11013ef90fe189f7.gif
//   //https://5b0988e595225.cdn.sohucs.com/q_70,c_zoom,w_640/images/20190514/eca8cb6ea55c42e2a1adec000b95e678.gif
//   //https://img0.baidu.com/it/u=143672386,1614197866&fm=253&fmt=auto&app=138&f=JPEG?w=300&h=300
//   //https://img0.baidu.com/it/u=348319454,612046564&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750
//   //https://picb2.photophoto.cn/40/293/40293462_1.jpg
//
//   //DeepAppLinkUtil.jumpByLinkOfOpenLink('jumpScheme://www.jump.com:8080/ansp/path')
//   // DeepAppLinkUtil.checkCanOpenLink('jumpScheme://www.jump.com:8080')
//   // DeepAppLinkUtil.jumpApp('C5765880207853008087', 'jumpSchemes://www.jump.com:8080/ansp/path')
//
// })