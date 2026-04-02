def main [] {
    let path = '/tmp/ocr.png'
    job spawn {
        niri msg --json event-stream | lines | each {|l|
            if ($l | from json) == {ScreenshotCaptured: {path: $path}} {
               job send 0
               return
            }
        }
    }
    niri msg action screenshot --path $path
    job recv
    # Delete copied photo from clip
    cliphist list | lines | first | cliphist delete $in
    tesseract $path stdout | wl-copy
}
