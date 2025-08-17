package example

import "core:fmt"
import "../imcanvas"

x_add_proc :: #type proc(
    canvas: ^Canvas,
    element: ^Element,
    parent: ^Element,
)

Element :: struct {
    data: int,
    parent: ^Element,
}

Canvas :: struct {
    elements: [dynamic]Element
}

canvas_init :: proc(element: Element) -> ^Canvas {
    @(static) canvas := Canvas{}
    free_all(canvas.elements.allocator)
    canvas.elements = make([dynamic]Element, context.temp_allocator)
    canvas_append(&canvas, element, nil)
    return &canvas
}

canvas_append :: proc(canvas: ^Canvas, element: Element, parent: ^Element) -> ^Element {
    append_elem(&canvas.elements, element)
    return &canvas.elements[len(canvas.elements) - 1]
}

main :: proc() {
    canvas : ^Canvas;
    canvas = canvas_init({data = 0})
    fmt.printfln("%p", canvas)
    canvas = canvas_init({data = 1})
    fmt.printfln("%p", canvas)
}