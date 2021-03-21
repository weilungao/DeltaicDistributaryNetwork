function dist_L( dist_A )
 
T=size(dist_A,3);
 
no=(1:504);
for Ti=no;
    Ti
    A_T=dist_A(:,:,Ti);
    A_T=A_T>0;
   
    %�˵�
    A_T_ept = bwmorph(A_T,'endpoints');
    %��֧��
    A_T_bpt = bwmorph(A_T,'branchpoints');
    %�ڵ�
    nodes=A_T_ept+A_T_bpt;
    ind_nodes=find(nodes==1);
    
    %����֧������������
    count_dist=1;
    for i=1:length(ind_nodes)
        for j=1:length(ind_nodes)
            if i==j
                continue
            else
                %���������ڵ�֮�����С·��
                D1 = bwdistgeodesic(A_T, ind_nodes(i), 'quasi-euclidean');
                D2 = bwdistgeodesic(A_T, ind_nodes(j), 'quasi-euclidean');
                D = D1 + D2;
                D = round(D * 8) / 8;
                D(isnan(D)) = inf;
                skeleton_path = imregionalmin(D);
                ind_path=find(skeleton_path);
                %ȥ�������ڵ�������ڵ�
                nodes_else=nodes;
                nodes_else(ind_nodes(i))=0;
                nodes_else(ind_nodes(j))=0;
                ind_nodes_else=find(nodes_else==1);
                %��ȡ·��������ڵ����
                count_nodes0=ismember(ind_path,ind_nodes_else);
                count_nodes0=sum(count_nodes0);
                %��ȡ·����Χ��������ڵ��index
                neig_node=[];
                for k=1:length(ind_path)
                    neig_node_tem=neig(ind_path(k),A_T);
                    neig_node=[neig_node,neig_node_tem];
                end
                %��ȡ·����Χ���ڵ�����ڵ�����
                neig_node=unique(neig_node);
                count_nodes=ismember(neig_node,ind_nodes_else);
                count_nodes=sum(count_nodes);
                %��ȡ·���˵���Χ���ڵ�����ڵ�����
                ind_node2=[ind_nodes(i),ind_nodes(j)];
                neig_node2=[];
                for k=1:length(ind_node2)
                    neig_node_tem=neig(ind_node2(k),A_T);
                    neig_node2=[neig_node2,neig_node_tem];
                end
                neig_node2=unique(neig_node2);
                count_nodes2=ismember(neig_node2,ind_nodes_else);
                count_nodes2=sum(count_nodes2);
                %�ж�·���Ƿ񾭹������ڵ�
                if count_nodes0>0
                    continue
                end
                %�ж�·����Χ�������ڵ�
                if count_nodes==0||count_nodes==count_nodes2
                    dist_m{count_dist, 1}= ind_nodes(i);
                    dist_m{count_dist, 2}=ind_nodes(j);
                    dist_m{count_dist, 3}=skeleton_path;
                    path_length = D(skeleton_path);
                    path_length = path_length(1);
                    dist_m{count_dist, 4}= path_length;
                    count_dist=count_dist+1;
                end
            end
        end
    end
    
if count_dist<=1;
    continue
end
    
    A_P=zeros(size(A_T));
    for i=1:size(dist_m,1)
        A_P=A_P+dist_m { i, 3 } ;
    end
    
%%%%%%%%%%%�ж��Ƿ���·���㱻�ظ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A_P1=A_P;
    A_P1(ind_nodes)=0;
    A_P1=A_P1>2;
    imlabel=bwlabel(A_P1);
    no_p=max(max(imlabel));
    %�����ظ��е���С֧��
    for i=1:no_p
        A_re=imlabel==i;
        ind_re=find(A_re>0);
        label_re=[];
        for j=1:size(dist_m)
            ind_dist=find(dist_m { j, 3 }>0);
            ind_j=ismember(ind_dist,ind_re);
            ind_j=sum(ind_j);
            if ind_j>0
                label_re=[label_re,j];
            end
        end
        L_label=[];
        for k=1:length(label_re)
            L_label=[L_label, dist_m{ label_re (k), 4 }];
        end
        L_min=min(L_label);
        ind_delete=find(L_label>L_min);
        ind_delete=label_re(ind_delete);
        dist_m(ind_delete,:)=[];
    end
%%%%%%%%%%%�ж��Ƿ���·���㱻�ظ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save_name=strcat('dist_m_',num2str(Ti));
    save(save_name,'dist_m')
    clear dist_m
end
end
