close all;

figure
subplot 411
title("Pendulum-Cart System")
plot(t,x(:,1))
ylabel("Position (m)")
subplot 412
plot(t,x(:,2))
ylabel("Velocity (m/s)")
subplot 413
plot(t,x(:,3)*180/pi)
ylabel("Angle (deg)")
subplot 414
plot(t,x(:,4)*180/pi)
ylabel("Angular Rate (deg/s)")
xlabel("Time (s)")
