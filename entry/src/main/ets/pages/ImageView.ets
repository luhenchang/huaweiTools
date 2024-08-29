import { image } from '@kit.ImageKit';
import { ImageCacheUtil } from '../utils/ImageCacheUtil';

@Component
export struct ImageView {
  @Prop imgUrl: string
  @State imageLocal: image.PixelMap | string | undefined = undefined;

  async aboutToAppear(): Promise<void> {
    let imageUtils = new ImageCacheUtil.Builder(getContext()).setImageFolderName('file').setCacheMaxSize(1024*1024*9).setNoCatchImageType(['.gif'])
      .build()
    this.imageLocal = await imageUtils.downLoadCacheFile(this.imgUrl)
  }

  build() {
    if (this.imageLocal) {
      Image(this.imageLocal)
    } else {
      LoadingProgress().color(Color.White)
    }
  }
}