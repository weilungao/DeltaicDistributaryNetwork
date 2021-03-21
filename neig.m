function ind=neig(ind0,A_T)

[Ay,Ax]=ind2sub(size(A_T),ind0);
neig_y=[-1,0,1,-1,0,1,-1,0,1];
neig_x=[-1,-1,-1,0,0,0,1,1,1];
Ayy=Ay+neig_y;
Axx=Ax+neig_x;
ind_nan_x1=find(Axx<=0);
ind_nan_x2=find(Axx>size(A_T,2));
ind_nan_y1=find(Ayy<=0);
ind_nan_y2=find(Ayy>size(A_T,1));
ind_nan=[ind_nan_x1,ind_nan_x2,ind_nan_y1,ind_nan_y2];
Ayy(ind_nan)=[];
Axx(ind_nan)=[];
ind=sub2ind(size(A_T),Ayy,Axx);

end

