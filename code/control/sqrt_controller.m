function y = sqrt_controller(x, kp, lim)

if lim < 0.0 || abs(lim)<eps || abs(kp)<eps
    y = x*kp;
    return;
end

dist = lim/kp^2;

if x > dist
    y = sqrt(2.0*lim*(x-(dist/2.0)));
elseif x < -dist
    y = -sqrt(2.0*lim*(-x-(dist/2.0)));
else
    y = x*kp;
end
