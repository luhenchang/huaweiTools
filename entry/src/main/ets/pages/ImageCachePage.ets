import { images } from '../data/data';
import { ImageView } from './ImageView';

@Entry
@Component
struct ImageCachePage {
  @State message: string = 'Hello World';

  build() {
    List({ space: 10 }) {
      ForEach(images, (imgUrl: string, index: number) => {
        ImageView({ imgUrl: imgUrl })
      })
    }.width('100%')
    .height('100%')
  }
}