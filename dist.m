function [A2, A3, bd2, bd3] = dist(SL_name,d_name,v_name,q_name,cd_SL,cd_ext)
 
d0=0.25;
v0=0.2;
q0=2.25e-5;
 
d_name=strcat(cd_ext,d_name);
load(d_name)
d=d(2:size(d,1)-1,2:size(d,2)-1);
dx0=25;L0=500;
idx=ceil(L0/dx0-0.5)+1;
d_s=d(:,idx:size(d,2));
bd=d>=d0;
bd_s=d_s>=d0;
 
v_name=strcat(cd_ext,v_name);
load(v_name);
vel=v(2:size(v,1)-1,2:size(v,2)-1);
dx0=25;L0=500;
idx=ceil(L0/dx0-0.5)+1;
vel_s=vel(:,idx:size(vel,2));
bv=vel>=v0;
bv_s=vel_s>=v0;
 
q_name=strcat(cd_ext,q_name);
load(q_name);
q=q(2:size(q,1)-1,2:size(q,2)-1);
q=q*25-q0;
dx0=25;L0=500;
idx=ceil(L0/dx0-0.5)+1;
q_s=q(:,idx:size(q,2));
bq=q>=0;
bq_s=q_s>=0;
 
bd2=bd+bv;
bd2=bd2==2;
bd_s2=bd_s+bv_s;
bd_s2=bd_s2==2;
 
bd3=bd+bv+bq;
bd3=bd3==3;
bd_s3=bd_s+bv_s+bq_s;
bd_s3=bd_s3==3;

A2=bd2;
imlabel=bwlabel(A2);
stats=regionprops(imlabel,'Area');
area=cat(1,stats.Area);
index=find(area==max(area));
A2=ismember(imlabel,index);
 
% Skeletonize  
skeletonizedImage = bwmorph(A2, 'thin', inf);  
% % distance transform.  
% Dist_Img = bwdist(~A);  
% % multiply  
A2 =single(skeletonizedImage);   
 
 
A3=bd3;
imlabel=bwlabel(A3);
stats=regionprops(imlabel,'Area');
area=cat(1,stats.Area);
index=find(area==max(area));
A3=ismember(imlabel,index);
 
% Skeletonize  
skeletonizedImage = bwmorph(A3, 'thin', inf);  
% % distance transform.  
% Dist_Img = bwdist(~A);  
% % multiply  
A3 =single(skeletonizedImage);
 
 
end
