/**
 * @author 610965
 * @data 2024/8/5 15:51
 */
@Component
export struct ScanTopLeftRect {
  @Prop cornerLineWidth: number = 4
  @Prop cornerLineLength: number = 30
  @Prop cornerLineColor: ResourceColor = Color.White

  build() {
    Column() {
      Row().width(this.cornerLineLength).height(this.cornerLineWidth).backgroundColor(this.cornerLineColor)
      Row().width(this.cornerLineWidth).height(this.cornerLineLength - this.cornerLineWidth).backgroundColor(this.cornerLineColor)
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.Transparent)
  }
}


@Component
export struct ScanTopRightRect {
  @Prop cornerLineWidth: number = 4
  @Prop cornerLineLength: number = 30
  @Prop cornerLineColor: ResourceColor = Color.White

  build() {
    Column() {
      Row().width(this.cornerLineLength).height(this.cornerLineWidth).backgroundColor(this.cornerLineColor)
      Row().width(this.cornerLineWidth).height(this.cornerLineLength - this.cornerLineWidth).backgroundColor(this.cornerLineColor)
    }.alignItems(HorizontalAlign.End)
    .backgroundColor(Color.Transparent)
  }
}


@Component
export struct ScanBottomLeftRect {
  @Prop cornerLineWidth: number = 4
  @Prop cornerLineLength: number = 30
  @Prop cornerLineColor: ResourceColor = Color.White

  build() {
    Column() {
      Row().width(this.cornerLineWidth).height(this.cornerLineLength - this.cornerLineWidth).backgroundColor(this.cornerLineColor)
      Row().width(this.cornerLineLength).height(this.cornerLineWidth).backgroundColor(this.cornerLineColor)
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.Transparent)
  }
}


@Component
export struct ScanBottomRightRect {
  @Prop cornerLineWidth: number = 4
  @Prop cornerLineLength: number = 30
  @Prop cornerLineColor: ResourceColor = Color.White

  build() {
    Column() {
      Row().width(this.cornerLineWidth).height(this.cornerLineLength - this.cornerLineWidth).backgroundColor(this.cornerLineColor)
      Row().width(this.cornerLineLength).height(this.cornerLineWidth).backgroundColor(this.cornerLineColor)
    }.alignItems(HorizontalAlign.End)
    .backgroundColor(Color.Transparent)
  }
}