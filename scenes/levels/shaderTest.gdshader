shader_type canvas_item;

varying vec3 some_color;

void vertex() {
    some_color = vec3(0); // Make the normal the color.
}

void fragment() {
    ALBEDO = some_color;
}

void light() {
    DIFFUSE_LIGHT = some_color * 100; // optionally
}