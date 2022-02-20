function [a,altitude] = groundTrackDesign(M,N,mu,w_body)
a = (M^2*mu/(N^2*w_body^2))^(1/3);
altitude = a-6378;
end