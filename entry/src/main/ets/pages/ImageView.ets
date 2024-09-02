import { image } from '@kit.ImageKit';
import { ImageCacheUtil } from '../utils/ImageCacheUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { CatchImage } from '../data/data';
import { router } from '@kit.ArkUI';

@Component
export struct ImageView {
  @Prop imgUrl: string
  @State imageLocal: image.PixelMap | string | undefined = undefined;
  imageCatchUtils: ImageCacheUtil | undefined = undefined

  async aboutToAppear(): Promise<void> {
    // this.imageCatchUtils = new ImageCacheUtil.Builder(getContext())
    //   .setImageFolderName('file')
    //   .setCacheMaxSize(1024 * 1024 * 9)
    //   .setNoCatchImageType(['.gif'])
    //   .build()
    // this.imageCatchUtils.downLoadCacheFile(this.imgUrl).then((data) => {
    //   this.imageLocal = data
    //   CatchImage.imageCatchPielMap = data
    // }).catch((err: BusinessError) => {
    //   console.error('error='+err.message)
    // })
  }

  build() {
    Column().onClick(() => {
    this.imageCatchUtils?.clearImageCache()
  }).width('100%').height('100%').backgroundColor(Color.Red).onClick(()=>{

    router.pushUrl({url:'pages/NextImageVisiblePage'})
  })
  }
}