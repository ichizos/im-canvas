package example

import "core:fmt"
import imc "../imcanvas"

main :: proc() {

    canvas := imc.init()

    if imc.layout_begin({
        sizing = { .FIXED, .FIXED },
        rect = { 0, 0, 800, 600 },
    }) {
        defer imc.layout_end()

        for i in 0 ..< 3 {
            if imc.layout_begin({
                direction = .LEFT_TO_RIGHT
            }) {
                defer imc.layout_end()

                for i in 0 ..< 3 {
                    imc.add_element(imc.Block {
                        sizing = { .FIXED, .FIXED },
                        rect = { 0, 0, 50, 50 }
                    })
                }
            }
        }
    }

    imc.calculate()

    for element in &canvas.elements {
        fmt.println(element)
    }
}