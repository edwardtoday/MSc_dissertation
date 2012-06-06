%    Author: Joshua Abraham
%    Email: algorithm007@hotmail.com
%    Description: match a test fingerprint of image 'f1' to a template fingerprint of image 'f2'.
%                 Preprocessing and feature extraction must already be performed (see extract_db.m).
%
%

function [sim, angle, sc_cost, E] = do_match(f1, f2)

%load template fingerprint
X=csvread( [char(f1) '.X']);
m1=csvread( [char(f1) '.m']);
oX=load( [char(f1) '.o']);
rX=load( [char(f1) '.r']);
nX = load( [char(f1) '.n']);  
roX = load( [char(f1) '.ro']);
orient_img_x = [];%load( [char(f1) '.oi']);
or_x = [];%load( [char(f1) '.oi']);

%load test fingerprint
Y=csvread( [char(f2) '.X']);
m2=csvread( [char(f2) '.m']);
oY=load( [char(f2) '.o']);
rY=load( [char(f2) '.r']);
nY = load( [char(f2) '.n']);  
roY = load( [char(f2) '.ro']);
orient_img_y = [];%load( [char(f2) '.oi']);
or_y = [];%load( [char(f2) '.oi']);


%Make sure all minutiae type are ridge endings, bifurcations, or primary cores (pseudo minutia).
i1=find(m1(:,3)<7);
i2=find(m2(:,3)<7);
X=X(i1,:);
m1=m1(i1,:);
Y=Y(i2,:);
m2=m2(i2,:);
m1r=m1(:,4);
m2r=m2(:,4);
m1(:,4)=mod(m1(:,4),pi);
m2(:,4)=mod(m2(:,4),pi);

%Attempt to retrieve index of both test and template fingerprint core indexes (provided they exist).
test = m1(:,3);
ic1  = find(test == 5);
c1o = -1;
c2o = -1;
test = m2(:,3);
ic2  = find(test == 5);


%Build fingerprint feature structure.
f1=struct('X', X, 'M', m1, 'O', oX, 'R', rX, 'N', nX, 'RO',roX, 'OIMG', orient_img_x, 'OREL', or_x); 
f2=struct('X', Y, 'M', m2, 'O', oY, 'R', rY, 'N', nY, 'RO',roY, 'OIMG', orient_img_y, 'OREL', or_y); 

%Bending energy
E=0;

%Detect if the core is near the edge of the fingerprint. Edge core comparisons have their similarity 
%reduced since they are more prone to error due to lack of distributed coverage about the core point 
%(i.e. much more possible alignment combinations are achieved when minutiae only lie on one side 
% of a core point since we have less rotational contraints).
edge_core = 0;
if numel(ic1) > 0 && numel(ic2) > 0
   a=max(f1.X(:,1));
   b=min(f1.X(:,1));
   if f1.X(ic1,1) > a-0.02 || f1.X(ic1,1) < b+0.02
      edge_core=1
   end
   a=max(f2.X(:,1));
   b=min(f2.X(:,1));
   if f2.X(ic2,1) > a-0.02 || f2.X(ic2,1) < b+0.02
      edge_core=1
   end
end

%Swap structures to make sure X represents the fingerprint with fewer minutiae
if size(X,1) > size(Y,1)
  temp = f1;
  f1 = f2;
  f2 = temp;
  temp = ic1;
  ic1 = ic2;
  ic2 = temp;
  temp = m1r;
  m1r = m2r;
  m2r = temp;
end

display_flag=0;
GC=0;

mean_dist_global=[]; % use [] to estimate scale from the data

nbins_theta=19; 
nbins_r=5;
eps_dum=1;  
r=0.35; % annealing rate
beta_init=0.8;  % initial regularization parameter (normalized)

r_inner=1/8; 
r_outer=1/2;  

%Register fingerprints
[ft,res]=register(f1,f2);
angle=0;
nsamp1=size(f1.X,1);
nsamp2=size(f2.X,1);
out_vec_1=zeros(1,nsamp1); 
out_vec_2=zeros(1,nsamp2);

d1=dist2(f1.X, f1.X);
d2=dist2(f2.X, f2.X);

o_res=[];
sc_res=[];
mc_res=[];
ro_res=[];

%Map out binding box for overlap region.
xt = min(ft.X(:,2));
xb = max(ft.X(:,2));
xl = min(ft.X(:,1));
xr = max(ft.X(:,1));
yt = min(f2.X(:,2));
yb = max(f2.X(:,2));
yl = min(f2.X(:,1));
yr = max(f2.X(:,1));
region_t=max(xt, yt);
region_b=min(xb, yb);
region_r=min(xr, yr);
region_l=max(xl, yl);
region_a = (region_b - region_t)*(region_r-region_l);

%Find all indices within bounding box
ind1=intersect(intersect(find(ft.X(:,1) > region_l), find(ft.X(:,1) < region_r)), intersect(find(ft.X(:,2) > region_t), find(ft.X(:,2) < region_b))  );
ind2=intersect(intersect(find(f2.X(:,1) > region_l), find(f2.X(:,1) < region_r)), intersect(find(f2.X(:,2) > region_t), find(f2.X(:,2) < region_b))  );

%get minutiae count for each image in overlap region
ng_samp1=numel(ind1);
ng_samp2=numel(ind2);

if numel(res.map) > 0 
   if numel(ic1) > 0 && numel(ic2) > 0
      GC=1;
   end

   f1=ft;
   inda1=res.map1;
   inda2=res.map2; 

   %find tighter minutiae count if possible for non core images 
   %which are more likely to have a much smaller overlap area 
   %then suggested by the bounding box. Convex hull structures
   %may be more accurate here.

   if GC ~=1 && ng_samp1*ng_samp2 > numel(inda1)*numel(inda2)
      % overlap region minutiae counts are set to nearest neighbour minutiae index counts
      ng_samp1=numel(inda1);
      ng_samp2=numel(inda2);
   end

   % overlap region index sets have anchor minutiae indexes removed.
   inda1=setdiff(inda1(find(f1.M(inda1,3) < 5)),res.map(:,1));
   inda2=setdiff(inda2(find(f2.M(inda2,3) < 5)),res.map(:,2));

   y=0;
   redo=[];
%   for i=1:size(res.map,1)
%       a1=mod(m1r(res.map(i,1))-res.angle,2*pi);
%       a2=m2r(res.map(i,2));

%       if min(abs(a1-a2), 2*pi-abs(a1-a2)) > pi/8 && f1.M(res.map(i,1),3) == f2.M(res.map(i,2),3)
%          y=y+1;
%          redo(y)=i;
%          inda1(numel(inda1)+1)=res.map(i,1);
%          inda2(numel(inda2)+1)=res.map(i,2);
%       end
%   end

   res.map=res.map(setdiff(1:size(res.map,1), redo),:);
   f1.M(:,4)=mod(m1r-res.angle,2*pi);

   orients=[];
   for i=1:numel(inda1)
       for j=1:numel(inda2)
           if f1.M(inda1(i),3) < 5 && f2.M(inda2(j),3) < 5 
              orients(i,j) = calc_orient(f1.X(inda1(i),:), f1.R(inda1(i),:), f2.X(inda2(j),:), f2.R(inda2(j),:), []);
           else
              orients(i,j)=0;
           end
       end
   end

   if numel(inda1) > 1 && numel(inda2 ) > 1
     if numel(inda1) > numel(inda2)
        orients=orients';
        t_res_map=res.map(:,[2,1]);
        [sc_cost3, E, cvec,angle] = tps_iter_match(f2.M, f1.M, f2.X, f1.X, orients, nbins_theta, nbins_r,r_inner,r_outer,3, r, beta_init, inda2, inda1, t_res_map);
        if numel(cvec) > 0
           xx=[inda1(cvec(:,2)); inda2(cvec(:,1))]'
123
           res.map=[res.map; xx]; 
        end
     else
        [sc_cost3, E, cvec,angle] = tps_iter_match(f1.M, f2.M, f1.X, f2.X, orients, nbins_theta, nbins_r,r_inner,r_outer,3, r, beta_init, inda1, inda2, res.map);

        if numel(cvec) > 0
           xx=[inda1(cvec(:,1)); inda2(cvec(:,2))]'
123
           res.map=[res.map; xx]; 
        end
     end
   end

   d1=sqrt(dist2(f1.X,f1.X));
   d2=sqrt(dist2(f2.X,f2.X));

   s1=numel(find(f1.M(:,3) < 5));
   s2=numel(find(f2.M(:,3) < 5));
else
   res.map=[];
   res.o_res=[];
end


nX=[];
nY=[];

ns=3;
n_weight=[];
same_type=[];


if numel(res.map) > 0 
   for i=1:size(res.map,1)
       if res.map(i,1) == 0 
          continue
       end    
       x=m1(res.map(i,1),1); 
       y=m1(res.map(i,1),2); 

       bonus=1;
       a1=mod(m1r(res.map(i,1))-res.angle,2*pi);
       a2=m2r(res.map(i,2));

       bonus=bonus*exp(-min(abs(a1-a2), 2*pi-abs(a1-a2)));

       if GC==1 && f1.M(res.map(i,1),3) ~= f2.M(res.map(i,2),3) 
          bonus=bonus-0.1;
          same_type(i)=0;
       else
          same_type(i)=1;
       end

       [dx,ii]=sort(d1(res.map(i,1),:));
       [dy,jj]=sort(d2(res.map(i,2),:));
       dd1=f1.N((res.map(i,1)-1)*(s1-1) + 1:(res.map(i,1)-1)*(s1-1) + ns,3:9);
       dd2=f2.N((res.map(i,2)-1)*(s2-1) + 1:(res.map(i,2)-1)*(s2-1) + ns,3:9);
       dd1(:,3)=mod(dd1(:,3)-res.angle,2*pi);
       dd2(:,3)=mod(dd2(:,3),2*pi);
       dd1(:,7)=mod(dd1(:,3),pi);
       dd2(:,7)=mod(dd2(:,3),pi);

       used=[];
       m_score = 0;
       t=1;
       for x=1:ns
           for y=1:ns
                  if numel(find(used==y)) 
                     continue
                  end
                  a_diff = min(abs(dd1(x,3)-dd2(y,3)), 2*pi-abs(dd1(x,3)-dd2(y,3)) );
                  dist_diff =  abs(dd1(x,1) - dd2(y,1));
                  lo_diff =  abs(dd1(x,6) - dd2(y,6));
                  o_diff=min(abs(dd1(x,7)-dd2(y,7)), pi-abs(dd1(x,7)-dd2(y,7)));
                  if dist_diff < 0.05 && a_diff < pi/2
                     m_score=m_score + exp(-o_diff)*exp(-dist_diff)*exp(-a_diff);
                     used(t)=y; t=t+1;
                  end
           end
        end
        if m_score == 0 
%          continue
        end

        n_weight(i)=m_score + bonus; 

       rox=f1.RO(res.map(i,1),:);
       roy=f2.RO(res.map(i,2),:);
       mox=f1.M(res.map(i,1),4);
       moy=f2.M(res.map(i,2),4);
       z=min([abs(mox-moy), abs(pi - abs(mox-moy))]) * 2/pi;

       t1=find(rox < 0);
       t2=find(roy < 0);
       t=[t1 t2 9];
       if numel(min(t)) > 0 
          rox=rox(1:min(t)-1);
          roy=roy(1:min(t)-1);
          ro_res(i)=max(abs(rox-roy));
          if ro_res(i) < 0.1 && min(t)>4
             n_weight(i)=n_weight(i)+0.2;
          end
       else
          ro_res(i)=0;
       end

       [o_res(i), ih]= calc_orient(f1.O(res.map(i,1),:), f1.R(res.map(i,1),:), f2.O(res.map(i,2),:), f2.R(res.map(i,2),:), [1:1]');  

       mc_res(i)=z;
       sc_res(i)=1;%costmat(res.map(i,1),res.map(i,2));
       res.map(setdiff(i,find(res.map(:,1)==res.map(i,1))), 1)=0;     
       res.map(setdiff(i,find(res.map(:,2)==res.map(i,2))), 1)=0;     
   end
end

sc_cost=100;

if numel(o_res) > 1
   inda1=union(inda1,res.map(:,1));
   inda2=union(inda2,res.map(:,2));

   A=f1.X(inda1,:);
   B=f2.X(inda2,:);
   out_vec_1=zeros(1,size(A,1)); 
   out_vec_2=zeros(1,size(B,1));

   [BH1,mean_dist_1]=sc_compute(A',f1.M(inda1,4)',mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);
   [BH2,mean_dist_2]=sc_compute(B',f2.M(inda2,4)',mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);
   %compute pairwise cost between all shape contexts
   costmat=hist_cost_2(BH1,BH2,r_inner, r_outer, nbins_theta, nbins_r);
   sc_vals=[];

   for i=1:numel(res.map)/2
       if numel(costmat(find(inda1==res.map(i,1)), find(inda2==res.map(i,2)))) > 0
          sc_vals(i)=costmat(find(inda1==res.map(i,1)), find(inda2==res.map(i,2)));
       else
          sc_vals(i)=10;
       end
   end
   sc_cost=mean(sc_vals);%/exp(-(0.7-max(sqrt(res.area),0))) 


end

unknown_c=numel(find(o_res == -1));

ind=intersect(find(o_res > 0.25), find(ro_res < 0.897)); 

for i=1:numel(ind)
    dd1=f1.N((res.map(ind(i),1)-1)*(s1-1) + 1:(res.map(ind(i),1)-1)*(s1-1) + ns,3:9);
    dd2=f2.N((res.map(ind(i),2)-1)*(s2-1) + 1:(res.map(ind(i),2)-1)*(s2-1) + ns,3:9);
end

o_res=o_res(ind);
ro_res=ro_res(ind);
mc_res=mc_res(ind);
sc_res=sc_res(ind);
n_weight=n_weight(ind);
same_type=same_type(ind);
%o_res=o_res.*n_weight;

res.sc/res.area;
res.sc;
ro_res; %=1/(sum(ro_res)/numel(ro_res))
o_res ;%=sum(o_res)/numel(o_res)
n_weight;
mc_res; %=1/sum(mc_res)/numel(mc_res)
sc_res;

nX=intersect(nX,ind1);
nY=intersect(nY,ind2);
numel(ind);
size(res.map,1);

ns1=numel(nX);
ns2=numel(nY);

ng_samp1=ng_samp1-unknown_c        %=ns1; %ng_samp1+(ns1/2);
ng_samp2=ng_samp2-unknown_c        %=ns2; %ng_samp2+(ns2/2);

ic1  = find(f1.M(:,3) == 5);
ic2  = find(f2.M(:,3) == 5);

%a=abs(ns1-ng_samp1) + abs(ns2-ng_samp2)
%4

o_a=zeros(numel(ind), numel(ind));
o_b=zeros(numel(ind), numel(ind));
for i=1:numel(ind)
    for j=i+1:numel(ind) 
        [o_a(i,j),ia,ra]=calc_orient(f1.O(res.map(i,1),:), f1.R(res.map(i,1),:), f1.O(res.map(j,1),:), f1.R(res.map(j,1),:),[]);  
        [o_b(i,j),ib,rb]=calc_orient(f2.O(res.map(i,2),:), f2.R(res.map(i,2),:), f2.O(res.map(j,2),:), f2.R(res.map(j,2),:), []);  
        o_a=min(o_a, 1);
        o_b=min(o_b, 1);

        if (numel(intersect(ra,rb)) < 120)
           o_a(i,j)=0;
           o_b(i,j)=0;
        end          
 
        o_a(j,i)=o_a(i,j);
        o_b(j,i)=o_b(i,j);
    end
end


vv=1;
if (numel(mc_res) >= 2) && res.area > -1
         hold on
%         figure(1)
		 subplot(2,2,4);
         plot(f1.X(:,1),f1.X(:,2),'b+',f2.X(:,1),f2.X(:,2),'ro')
         if GC == 1
  %          plot(f1.X(ic1,1),f1.X(ic1,2),'g+',f2.X(ic2,1),f2.X(ic2,2),'go')
         end 
         title(['final'])
         hold off
         drawnow

   v=max(abs(o_a-o_b));
   vv=median(v)
   sim=(numel(mc_res)^2)*sqrt(max(o_res))*mean(n_weight)/max((ng_samp1*ng_samp2),1);
   if edge_core == 1
      sim=sim*0.5;
   end
else
   sim=0;
end
sc_cost
sim

