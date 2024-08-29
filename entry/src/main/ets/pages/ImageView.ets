import { image } from '@kit.ImageKit';
import { ImageCacheUtil } from '../utils/ImageCacheUtil';

@Component
export struct ImageView {
  @Prop imgUrl: string
  @State imageLocal: image.PixelMap | string | undefined = undefined;
  imageCatchUtils: ImageCacheUtil | undefined = undefined

  async aboutToAppear(): Promise<void> {
    this.imageCatchUtils = new ImageCacheUtil.Builder(getContext()).setImageFolderName('file')
      .setCacheMaxSize(1024 * 1024 * 9)
      .setNoCatchImageType(['.gif'])
      .build()
    this.imageLocal = await this.imageCatchUtils.downLoadCacheFile(this.imgUrl)
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