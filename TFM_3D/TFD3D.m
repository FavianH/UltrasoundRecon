function [image] = TFD3D(Points, data, geo)
% t = 0:geo.f:1;
image = zeros(geo.nx, geo.ny, geo.nz);
[X, Y, Z] = meshgrid(1:size(image, 1), 1:size(image, 2), 1:size(image, 3));
X = permute(X, [2, 1, 3]);
Y = permute(Y, [2, 1, 3]);

for uu = 1:size(Points)
    for vv = 1:size(Points)
        d_t = sqrt((X * geo.dx - Points(uu, 1)) .^ 2 + (Y * geo.dy - Points(uu, 2)) .^ 2 + (Z * geo.dz - Points(uu, 3)) .^ 2);
        d_r = sqrt((X * geo.dx - Points(vv, 1)) .^ 2 + (Y * geo.dy - Points(vv, 2)) .^ 2 + (Z * geo.dz - Points(vv, 3)) .^ 2);

        t = ((d_t + d_r) / geo.c) * geo.f;
        signal = data(uu, vv, :);
        image = image + t .* (signal(ceil(t)) + signal(floor(t))) ./ (ceil(t) + floor(t)) .* sqrt(d_t .* d_r);

%         imtool(image, []);
    end
end
end