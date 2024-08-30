import { image } from '@kit.ImageKit';
import { ImageCacheUtil } from '../utils/ImageCacheUtil';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct ImageView {
  @Prop imgUrl: string
  @State imageLocal: image.PixelMap | string | undefined = undefined;
  imageCatchUtils: ImageCacheUtil | undefined = undefined

  async aboutToAppear(): Promise<void> {
    this.imageCatchUtils = new ImageCacheUtil.Builder(getContext())
      .setImageFolderName('file')
      .setCacheMaxSize(1024 * 1024 * 9)
      .setNoCatchImageType(['.gif'])
      .build()
    this.imageCatchUtils.downLoadCacheFile(this.imgUrl).then((data) => {
      this.imageLocal = data
    }).catch((err: BusinessError) => {
      console.error('error='+err.message)
    })
  }

  build() {
    if (this.imageLocal) {
      Image(this.imageLocal).onClick(() => {
        this.imageCatchUtils?.clearImageCache()
      })
    } else {
      LoadingProgress().color(Color.White)
    }
  }
}