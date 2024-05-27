const std = @import("std");
const pi = std.math.pi;
const cairo = @import("cairo");
const setBackground = @import("utils.zig").setBackground;

/// https://github.com/pygobject/pycairo/blob/master/examples/pycairo_examples.ipynb
/// https://gitlab.com/cairo/cairo-demos/-/blob/master/png/spiral.c
fn spiral(cr: *cairo.Context, width: f64, height: f64) void {
    cr.setSourceRgb(0, 0, 1); // blue

    const line_width: f64 = 4.0;
    const half_lw = line_width / 2.0;
    cr.setLineWidth(line_width);

    // k controls the space between the spiral's windings
    const k = line_width * 0.01;
    const wd = k * width;
    const hd = k * height;
    const w = width - line_width;
    const h = height - line_width;

    // start from the top right corner
    cr.moveTo(w + half_lw, -hd + half_lw);

    const num_windings: f64 = 12;
    var i: f64 = 0;
    while (i < num_windings) : (i += 1) {
        cr.relLineTo(0, h - hd * (2 * i - 1)); // go down
        cr.relLineTo(-(w - wd * (2 * i)), 0); // go left
        cr.relLineTo(0, -(h - hd * (2 * i))); // go up
        cr.relLineTo(w - wd * (2 * i + 1), 0); // go right
    }
    cr.stroke();
}

pub fn main() !void {
    const width: u16 = 400;
    const height: u16 = 400;
    const surface = try cairo.ImageSurface.create(.argb32, width, height);
    defer surface.destroy();

    const cr = try cairo.Context.create(surface.asSurface());
    defer cr.destroy();

    setBackground(cr);
    spiral(cr, @floatFromInt(width), @floatFromInt(height));
    try surface.writeToPng("examples/generated/spiral.png");
}
