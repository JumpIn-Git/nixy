{
  writers,
  cliphist,
  tesseract,
  wl-clipboard,
  lib,
  ...
}:
writers.writeNuBin "niri-ocr" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [cliphist wl-clipboard tesseract]}"
  ];
} (builtins.readFile ./main.nu)
