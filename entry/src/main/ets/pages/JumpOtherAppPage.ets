import { url } from '@kit.ArkTS';

@Entry
@Component
struct JumpOtherAppPage {
  @State inputTextOnePlaceHolder: string = 'jumpScheme://www.jump.com:8080/ansp/path';

  aboutToAppear(): void {

  }

  parseUrl(urlString: string): boolean {
    let urls = url.URL.parseURL(urlString)
    if (urls.protocol.includes('http:') || urls.protocol.includes('https:')) {
      return true
    } else {
      return false
    }
  }

  build() {
    RelativeContainer() {
      Text(this.parseUrl('http://www.baidu.com') ? '网络链接' : '不是网络链接').id('titleTvId').alignRules(
        {
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        }
      ).fontSize(20).fontWeight(FontWeight.Bold)
      Column() {
        Text('跳转三方应用').margin({ bottom: 10 }).textShadow({ radius: 3, color: Color.Black })
        Row() {
          TextInput(
            {
              placeholder: $r('app.string.please_input_link'),
              text: `${this.inputTextOnePlaceHolder}`
            }).onChange((value: string) => {
            this.inputTextOnePlaceHolder = value
          }).layoutWeight(1).id('textInputId')
          Button() {
            Text("跳转").fontColor(Color.White)
          }.padding({
            left: 15,
            right: 15,
            top: 5,
            bottom: 5
          }).margin({ left: 10 })
        }.alignItems(VerticalAlign.Center)

      }
      .alignItems(HorizontalAlign.Start)
      .id('columnId')
      .alignRules({
        top: { anchor: 'titleTvId', align: VerticalAlign.Bottom },
      }).margin({ top: 50 })


      // Text(this.inputTextOnePlaceHolder)
      //   .id('JumpOtherAppPageHelloWorld')
      //   .fontSize(50)
      //   .fontWeight(FontWeight.Bold)
      //   .alignRules({
      //     center: { anchor: '__container__', align: VerticalAlign.Center },
      //     middle: { anchor: '__container__', align: HorizontalAlign.Center }
      //   })
      //   .onClick(() => {
      //     DeepAppLinkUtil.jumpByLinkOfOpenLink('jumpScheme://www.jump.com:8080/ansp/path')
      //     //DeepAppLinkUtil.jumpByLinkOfAppLinking()
      //     DeepAppLinkUtil.checkCanOpenLink('jumpScheme://www.jump.com:8080')
      //     DeepAppLinkUtil.jumpApp('C5765880207853008087', 'jumpSchemes://www.jump.com:8080/ansp/path')
      //   })
    }
    .height('100%')
    .width('100%')
    .padding(20)
  }
}