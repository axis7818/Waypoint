void main() {
    float dash = 15.0;
    float x = mod(v_path_distance, float(2.0 * dash));
    if (x > dash) {
        discard;
    }
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
