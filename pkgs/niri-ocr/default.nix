{
  writers,
  lib,
  cliphist,
  tesseract,
  wl-clipboard,
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
