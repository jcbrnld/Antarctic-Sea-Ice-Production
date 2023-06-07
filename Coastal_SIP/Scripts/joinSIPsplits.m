% Jacob Arnold

% 05-May-2022

% Join SIP data for sectors 3 + 3b, 4 + 4b, and 8 + 7b

% sector 3
load ICE/Production/data/SIP/original_split/sector03.mat;
s1 = SIP; clear SIP
load ICE/Production/data/SIP/original_split/sector03b.mat;
s2 = SIP; clear SIP

SIP.longdn = s1.longdn;
SIP.longdv = s1.longdv;
SIP.middn = s1.middn;
SIP.middv = s1.middv;
SIP.P = s1.P+s2.P;
SIP.transport = s1.transport+s2.transport;
SIP.dSIV = s1.dSIV+s2.dSIV;
SIP.comment = s1.comment;

save('ICE/Production/data/SIP/sector03.mat')

%% Sector 4

load ICE/Production/data/SIP/original_split/sector04.mat;
s1 = SIP; clear SIP
load ICE/Production/data/SIP/original_split/sector04b.mat;
s2 = SIP; clear SIP

SIP.longdn = s1.longdn;
SIP.longdv = s1.longdv;
SIP.middn = s1.middn;
SIP.middv = s1.middv;
SIP.P = s1.P+s2.P;
SIP.transport = s1.transport+s2.transport;
SIP.dSIV = s1.dSIV+s2.dSIV;
SIP.comment = s1.comment;

save('ICE/Production/data/SIP/sector04.mat')



%% Sector 8

load ICE/Production/data/SIP/original_split/sector08.mat;
s1 = SIP; clear SIP
load ICE/Production/data/SIP/original_split/sector07b.mat;
s2 = SIP; clear SIP

SIP.longdn = s1.longdn;
SIP.longdv = s1.longdv;
SIP.middn = s1.middn;
SIP.middv = s1.middv;
SIP.P = s1.P+s2.P;
SIP.transport = s1.transport+s2.transport;
SIP.dSIV = s1.dSIV+s2.dSIV;
SIP.comment = s1.comment;

save('ICE/Production/data/SIP/sector08.mat')




