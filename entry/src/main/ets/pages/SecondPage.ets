@Builder
function PagesMap(name: string) {
  if (name === 'DialogPage') {
    DialogPage()
  }
  if (name === 'PageOne') {
    PageOne()
  }
}

@Entry
@Component
struct CustomDialogNotDisappear {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack();



  build() {
    Navigation(this.pageStack) {
      Button('Push DialogPage')
        .fontSize(16)
        .width(328)
        .backgroundColor('#0A59F7')
        .onClick(() => {
          this.pageStack.pushPathByName('DialogPage', '');
        })
    }
    .mode(NavigationMode.Stack)
    .title('Main')
    .navDestination(PagesMap)
  }
}

@Component
export struct DialogPage {
  @Consume('NavPathStack') pageStack: NavPathStack;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text('Dialog NavDestination')
            .fontSize(16)
            .margin({ top: 24 })
          Row() {
            Button('confirm')
              .fontSize(16)
              .width(328)
              .backgroundColor('#0A59F7')
              .onClick(() => {
                this.pageStack.pushPathByName('PageOne', 'PageOne Param');
              })
              .width('100%')
              .margin({
                top: 8,
                bottom: 16
              })
          }
          .padding({
            left: 16,
            right: 16
          })
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(24)
        .width(328)
      }
      .height('100%')
      .width('100%')
    }
    .onClick(()=>{
      this.pageStack.pop()
    })
    .backgroundColor('rgba(0,0,0,0.5)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}

@Component
export struct PageOne {
  @Consume('NavPathStack') pageStack: NavPathStack;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text('PageOne')
            .fontSize(20)
            .margin({ bottom: 100 })
          Button('back')
            .fontSize(16)
            .width(328)
            .backgroundColor('#0A59F7')
            .onClick(() => {
              this.pageStack.pop();
            })
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Orange)
        .borderRadius(10)
        .height('100%')
        .width('100%')
      }
      .height('100%')
      .width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.5)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}