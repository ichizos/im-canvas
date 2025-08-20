package imc

import "core:fmt"
import container "core:container/queue"

Sizing :: enum {
    AUTO,
    FIXED,
}

Direction :: enum {
    TOP_TO_BOTTOM,
    LEFT_TO_RIGHT,
}

Block :: struct {
    rect: [4]int,
    //    border: [4]int,
    //    padding: [4]int,
    //    gap: [2]int,
    //    color: [4]u8,
    //    border_color: [4]u8,
    sizing: [2]Sizing,
    direction: Direction,
}

Text :: struct {
    color: [4]u8,
    str: string,
}

Element_ID :: distinct int

Element_Data :: union {
    Block,
    Text,
}

Element :: struct {
    id: Element_ID,
    parent_id: Element_ID,
    data: Element_Data,
}

Canvas :: struct {
    elements: [dynamic]Element,
    parent_stack: container.Queue(Element_ID),
}

canvas: Canvas

init :: proc() -> ^Canvas {
    canvas.elements = make([dynamic]Element, context.temp_allocator)
    err := container.init(&canvas.parent_stack)
    assert(err == .None, fmt.aprintf("Error when allocating parent_stack Queue: %s", err) )
    return &canvas;
}

get_element :: proc(id: Element_ID) -> ^Element {
    element := &canvas.elements[id - 1]
    assert(id == element.id, fmt.aprintf("Mismatch between requested ID. Expected: %s, Actual: %s", id, element.id))
    return element
}

add_element :: proc(element_data: Element_Data) -> (id: Element_ID) {
    parent_id := container.back(&canvas.parent_stack)
    _, err := append_elem(&canvas.elements, Element {
        parent_id = parent_id,
        data = element_data
    })
    assert(err == .None, fmt.aprintf("Error when appending an element: %s", err));
    id = Element_ID(len(canvas.elements))
    element := &canvas.elements[id - 1];
    element.id = id
    assert(element.id > 0, fmt.aprintf("Appened element has invalid ID: %s", id))
    return
}

layout_begin :: proc(box: Block) -> bool {
    id := add_element(box);
    ok, _ := container.push(&canvas.parent_stack, id)
    return ok;
}

layout_end :: proc() {
    container.pop_back(&canvas.parent_stack);
}

calculate :: proc() {
    #reverse for current in &canvas.elements {
        if current.parent_id == 0 do continue

        parent_data := &get_element(current.parent_id).data.(Block);

        #partial switch data in current.data {
        case Block:
            if parent_data.sizing.x == Sizing.AUTO do parent_data.rect.z += data.rect.z
            if parent_data.sizing.y == Sizing.AUTO do parent_data.rect.w += data.rect.w
        }
    }
}