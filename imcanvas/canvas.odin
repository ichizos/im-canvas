package imc

Sizing :: enum {
    AUTO,
    FIXED,
}

Direction :: enum {
    TOP_TO_BOTTOM,
    LEFT_TO_RIGHT,
}
Element_Kind :: enum {
    BOX,
    TEXT
}

Element :: struct {
    rect: [4]int,
    //    border: [4]int,
    //    padding: [4]int,
    //    gap: [2]int,
    //    color: [4]u8,
    //    border_color: [4]u8,
    sizing: [2]Sizing,
    //    direction: Direction,
    content: string,
    kind: Element_Kind,
    id: int,
}

Canvas :: struct {
    elements: [dynamic]Element
}

canvas_init :: proc(element: Element) -> Canvas {
    canvas: Canvas = {
        elements = make([dynamic]Element, context.temp_allocator),
    }
    canvas_add(&canvas, element)
    return canvas;
}

canvas_end :: proc(canvas: ^Canvas) {
}

canvas_add :: proc(canvas: ^Canvas, element: Element) {
    _, err := append_elem(&canvas.elements, element)
    assert(err == nil, "Error when adding an element");

    id := len(canvas.elements)
    canvas.elements[id - 1].id = id
}

imc :: proc(parent: int, children: ..int) -> int {
    return parent
}
