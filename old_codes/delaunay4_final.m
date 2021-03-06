clc;
clear all;
close all;

%% input points

pts = [1,1;
    6,6;
    12,3;
    15,3;
    12,1;
    4,8;
    7,9;
    9,3;
    11,13;
    12,5;
    2,12;
    10,11;
    4,2
    ];
pts = unique(randi([1,200],1000,2),'rows');
pts = [pts,[1:size(pts,1)]'];
scatter(pts(:,1),pts(:,2),'.');         %showing points

% all points are denoted by [x y index]

%% delaunay triangulation by matlab
figure;

tri = delaunay(pts(:,1:2));      %delaunay triangulation using MATLAB
patch('Faces',tri,'Vertices',pts,'FaceColor','none');

%% algorihm

% creating the super triangle which will contain all the points inside it
xmax = max(pts(:,1));       xmin = min(pts(:,1));
ymax = max(pts(:,2));       ymin = min(pts(:,2));
spacing = 20;
p1_s = [xmin-spacing,ymin-spacing,size(pts,1)+1];
p2_s = [xmax+spacing,ymin-spacing,size(pts,1)+2];
p3_s = [0.5*(xmax+xmin),ymax+spacing,size(pts,1)+3];
pts_new = [pts;p1_s;p2_s;p3_s];
tri_s = [p1_s(1,3),p2_s(1,3),p3_s(1,3)];


tri = [tri_s];
tri_main = [];
edgep= [];
bt = [];
bt_edges = [];
for i1 = 1:size(pts,1)
    fprintf('\n----------loopstart--------------\n')
%     hold on;
figure;
    scatter(pts(i1,1),pts(i1,2),'g');
    for j = 1:size(tri,1)           % for loop for triangles
        [center,r] = circumc(pts_new(tri(j,1),1:2),...
            pts_new(tri(j,2),1:2),...
            pts_new(tri(j,3),1:2));         % getting center anbd radius of the circumcircle
        
        if (pts(i1,1)-center(1))^2 + (pts(i1,2)-center(2))^2-r^2 <0
            fprintf('\ninside the circle\n');
            bt = [bt;tri(j,:)]
            bt_edges = [bt_edges;tri(j,1),tri(j,2);tri(j,1),tri(j,3)...
                ;tri(j,2),tri(j,3)]
            
        else
            fprintf('\non or outside the circle\n');
        end
    end
    
        for i = 1:size(bt_edges,1)
            if bt_edges(i,1)>bt_edges(i,2)
                bt_edges(i,:) = fliplr(bt_edges(i,:));
            end
        end
    bt_edges

        
    for i = 1:size(bt_edges,1)
        uval = ismember(bt_edges,bt_edges(i,:),'rows');
        if sum(uval)==1
            edgep = [edgep;bt_edges(i,:)];     %edge of polygon
        end
    end
    edgep
    
    %plotting polygon
     for k1 = 1: size(edgep,1)
        plot_poly = [pts_new(edgep(k1,1),1:2);pts_new(edgep(k1,2),1:2)];
        hold on;
        plot(plot_poly(:,1),plot_poly(:,2),'k','LineWidth',2)
    end
    
    %triangulation
    tri = [tri;edgep,i1.*ones(size(edgep,1),1)]
%     tri = [tri;gt]
    % potting triangles
    
    for k = 1: size(tri,1)
        plot_pts = [pts_new(tri(k,1),1:2);pts_new(tri(k,2),1:2);...
            pts_new(tri(k,3),1:2);pts_new(tri(k,1),1:2)];
        hold on;
        plot(plot_pts(:,1),plot_pts(:,2),'r')
    end
    
    tri  = setdiff(tri,bt,'rows')
    bt = [];
    bt_edges = [];
    edgep = [];
end

% 
tri_new = [];
for i = 1:size(tri,1)
   if tri(i,1)~=size(pts,1)+1 && tri(i,1)~=size(pts,1)+2 && tri(i,1)~=size(pts,1)+3
       if tri(i,2)~=size(pts,1)+1 && tri(i,2)~=size(pts,1)+2 && tri(i,2)~=size(pts,1)+3
           if tri(i,3)~=size(pts,1)+1 && tri(i,3)~=size(pts,1)+2 && tri(i,3)~=size(pts,1)+3
    tri_new = [tri_new;tri(i,:)];
           end
       end
   end
end
tri_new = unique(tri_new,'rows')
figure;
scatter(pts(:,1),pts(:,2),'.'); 
hold on;
for k = 1: size(tri_new,1)
        plot_pts = [pts_new(tri_new(k,1),1:2);pts_new(tri_new(k,2),1:2);...
            pts_new(tri_new(k,3),1:2);pts_new(tri_new(k,1),1:2)];
        hold on;
        plot(plot_pts(:,1),plot_pts(:,2),'k')
end





% gt_new = [];
% for i = 1:size(gt,1)
%    if gt(i,1)~=9 && gt(i,1)~=10 && gt(i,1)~=11
%        if gt(i,2)~=9 && gt(i,2)~=10 && gt(i,2)~=11
%            if gt(i,3)~=9 && gt(i,3)~=10 && gt(i,3)~=11
%     gt_new = [gt_new;gt(i,:)];
%            end
%        end
%    end
% end
% gt_new = unique(gt_new,'rows')
% figure;
% scatter(pts(:,1),pts(:,2),'.'); 
% hold on;
% for k = 1: size(gt_new,1)
%         plot_pts = [pts_new(gt_new(k,1),1:2);pts_new(gt_new(k,2),1:2);...
%             pts_new(gt_new(k,3),1:2);pts_new(gt_new(k,1),1:2)];
%         hold on;
%         plot(plot_pts(:,1),plot_pts(:,2),'k')
% end
    

% hold on;
%  plot_pts = [pts_new(9,1:2);pts_new(11,1:2);...
%                 pts_new(1,1:2);pts_new(9,1:2)];
%        plot(plot_pts(:,1),plot_pts(:,2),'LineWidth',2)