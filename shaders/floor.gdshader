shader_type spatial;

uniform float size : hint_range(1.0, 100.0) = 25.0;
uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.7, 0.7, 0.7, 1.0);

void fragment() {
    // Use FRAGCOORD or UV coordinates based on your needs
    vec2 pos = floor(UV * size);
    float pattern_mask = mod(pos.x + mod(pos.y, 2.0), 2.0);

    // For 3D shaders, we set ALBEDO instead of COLOR
    ALBEDO = mix(color1.rgb, color2.rgb, pattern_mask);

    // Optional: Set other material properties if needed
    METALLIC = 0.0;
    ROUGHNESS = 1.0;
    SPECULAR = 0.0;
}