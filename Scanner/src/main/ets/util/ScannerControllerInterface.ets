/**
 * @author 610965
 * @data 2024/8/16 11:23
 */
export interface ScannerControllerInterface {
  openLight(): void

  closeLight(): void

  toggleLight(): void

  pickPhoto(): void

  setZoom(zoom: number): void

  getZoom(): number

  getLightStatus(): boolean

  releaseScan(): void

  startScan(): void

  rescan(): void

  scanUri(uri: string): void

  scanUrl(url: string): void

  scanPixelMap(pixelMap: PixelMap): void
}