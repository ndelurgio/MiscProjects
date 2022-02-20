close all;

figure
subplot 411
title("Pendulum-Cart System")
plot(t,x(:,1))
ylabel("Position")
subplot 412
plot(t,x(:,2))
ylabel("Velocity")
subplot 413
plot(t,x(:,3)*180/pi)
ylabel("Angle")
subplot 414
plot(t,x(:,4)*180/pi)
ylabel("Angular Rate")
xlabel("Time (s)")
