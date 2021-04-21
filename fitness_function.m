function C = fitness_function(K)

% Observation time
tf = 30; 
count = 0;
% Gain K 
kp1=K(1);
kp2=K(2);
ki1=K(3);
ki2=K(4);
kd1=K(5);
kd2=K(6);

% System result for these K
[x,t,u] = simclosedloop(kp1,kp2,ki1,ki2,kd1,kd2,tf);

% States x
x1 = x(:,1);
x2 = x(:,2);
x3 = x(:,3);
x4 = x(:,4);

% Inputs u 
u1 = u(:,1);
u2 = u(:,2);

% Desired outputs
y1d = 90*pi/180 + 30*pi*cos(t)/180;
y2d = 90*pi/180 + 30*pi*sin(t)/180;

% Errors
e1 = x1 - y1d;
e2 = x3 - y2d;
e = [e1 e2];

%% Find J1  
% Find if the last k = 50 values are within [-pi/180,pi/180]
i1=length(e1);
i2=length(e2);
k = 50;
C = 0;

l1 = e1(i1-k:i1);
l2 = e2(i2-k:i2);

if (l1>=-(pi/180) & l1<=(pi/180))
disp("e1 okay")
else
    count = count + 1; %not meeting the requirements
end
if (l2>=-(pi/180) & l2<=(pi/180))
disp("e2 okay")
else
    count = count + 1; %not meeting the requirements
end

%% Find J2
% e1(0)<0 and e2(0)>0
J2_1 = abs(max(e1)); 
J2_2 = abs(min(e2));

J2 = max(J2_2,J2_1);

%% Find J3
% Search from end to start to find which (t) moment is the last time the
% value of the error belong to [-pi/180,pi/180]
while( e1(i1)>=-(pi/180) && e1(i1)<=(pi/180) )
    i1=i1-1;
end
J3_1  = t(i1);

while( e2(i2)>=-(pi/180) && e2(i2)<=(pi/180) )
    i2=i2-1;
end
J3_2  = t(i2);

J3 = max(J3_1,J3_2);
%% Find J4
J4 = max(max(abs(u1)),max(abs(u2)));

%% Find J5
u1_diff = diff(u1)./0.1;
u2_diff = diff(u2)./0.1;

J5 = max(max(abs(u1_diff)),max(abs(u2_diff)));

%% Find J6
J6_1 = sum(abs(u1_diff));
J6_2 = sum(abs(u2_diff));
J6 = max(J6_1,J6_2);

%% Which of the requirements are fulfilled

if (J2 > pi/180)
    count = count + 1;
end
if (J3 > 1)
    count = count + 1;
end
if J4 > 18
    count = count + 1;
end
if J5 > 160
    count = count + 1;
end

%% Fitness
if count == 0 
    C = (J4*50/(3*18) + J5*50/(3*160) + J6/50);
    if C>50
        C=50;
    end
else
    C = 49 + count*50/6 ;
end

end
