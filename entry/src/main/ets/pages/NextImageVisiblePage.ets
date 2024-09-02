import { ImageCacheUtil } from '../utils/ImageCacheUtil';
import { CatchImage } from '../data/data';

@Entry
@Component
struct NextImageVisiblePage {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Image(CatchImage.imageCatchPielMap).width('100%').height('100%')
    }
  }
}