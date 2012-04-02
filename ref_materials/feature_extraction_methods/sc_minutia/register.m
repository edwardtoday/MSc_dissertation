%    Author: Joshua Abraham
%    Email: algorithm007@hotmail.com
%    Description: 
%
%


function [fr, similarity] = register(f1,f2)

cla
fr=struct('X', [], 'M', [], 'O', [], 'R', [], 'N', [], 'RO',[]); 
similarity=struct('map', [], 'o_res', [], 'sc', -1, 'area', -1 ); 


VERBOSE=0;
m1=f1.M;
m2=f2.M;
m1=mod(f1.M,pi);
m2=mod(f2.M,pi);
m1s=find(m1(:,3) > 3);
m2s=find(m2(:,3) > 3);

singular1=f1.X(m1s,:);
singular2=f2.X(m2s,:);

m_map1=[];
m_map2=[];

m1=f1.M;
m2=f2.M;
X=f1.X;
Y=f2.X;
oX=f1.O;
oY=f2.O;
rX=f1.R;
rY=f2.R;
nX=f1.N; 
nY=f2.N; 
roX=f1.RO;
roY=f2.RO;

ic1  = find(f1.M(:,3) == 5);
ic2  = find(f2.M(:,3) == 5);


low_core=0;
if numel(ic1) > 0 && f1.M(ic1,2) > 363
   low_core=1;
end

if numel(ic2) > 0 && f2.M(ic2,2) > 363
   low_core=1;
end


edge_core = 0;

if numel(ic1) > 0 && numel(ic2) > 0
   GC=1;
else
  if numel(singular1) == 0 || numel(singular2) == 0 
     GC=0;
  else
     %core should be below image since we most likely
     % have a huge region without any singularities (cores).
     % i.e Max distance from core to singularity is limited.
     % this idea assumes no heavy noise for core.
     if numel(ic1) > 0 && numel(find(f2.M(m2s,2) < 300))==0 
        GC=3;
     elseif numel(ic2) > 0 && numel(find(f1.M(m1s,2) < 300))==0
        GC=4; 
     else  
        GC=2;
     end
  end
end

orients = 100 * ones(size(X,1), size(Y,1));
orients_x = zeros(size(X,1), size(X,1));
orients_y = zeros(size(Y,1), size(Y,1));
orient_prob = zeros(size(X,1), size(Y,1));

for i=1:size(X,1)
   for j=1:size(Y,1)
     if m1(i,3) < 5 && m2(j,3) < 5 
        orients(i,j) = calc_orient(oX(i,:), rX(i,:), oY(j,:), rY(j,:), [1:1]');
     end
   end
end

ndum1=0; 
ndum2=0; 
eps_dum=1;
nsamp1=size(X,1);
nsamp2=size(Y,1);
mean_dist_global=[]; 
display_flag = 1;
if nsamp2>nsamp1               % (as is the case in the outlier test)       
   ndum1=ndum1+(nsamp2-nsamp1);      
end                                                                                     
eps_dum=1; 

%JI: store minimum error in iterations to avoid 
% large jumps away from global minima to local minima
min_error = -1;

jjj=-1;
region_a=1;
m1a=[];
m2a=[];

% theta offset after warping from last iteration and the total theta offset
% from the start (in radians)
% 28/7/2006 (Paul Kwan)
theta_offset_total = 0;

% initialize counter
k=1;
s=1;
% out_vec_{1,2} are indicator vectors for keeping track of estimated
% outliers on each iteration

angle = -1;
min_1 = 0;
min_2 = 0;
test_val = 100;
oco = 0;
ocm = 100;
oo=0;
test_n = 0;
iu_y = 0; iu_x = 0;

Xo = [];
l = 10;
hc = 100;


sing1=[];
cdist=-1;
map=[];
o_res=[];
out_vec_1=zeros(1,nsamp1+1); 
out_vec_2=zeros(1,nsamp2+1);
dist_m=[];
orient_m=[];

sc=-1; 
area=-1;
c_ratio=0;

i1=[];
i2=[];

for i=1 : nsamp1 
    for j =1: nsamp2 

     t_angle = m1(i,4) - m2(j,4);                                                       


     if abs(t_angle) > pi/2.75  || m1(i,3)>=5 || m2(j,3)>=5  || orients(i,j) < 0.25 %|| m1(i,3) ~= m2(j,3) 
        continue;                
     end

     sct=0; region_a=0;

     r_t =  m2(j,4) -  m1(i,4);   
     m1t = m1(:,4);
     v = X(:,2);
     w = X(:,1);
     Xt = X;       
     Xta = Xt; 
     Xt(:,2) = v*cos(r_t) - w*sin(r_t);  
     Xt(:,1) = v*sin(r_t) + w*cos(r_t);  
      
     diffx = Xt(i,1)   - Y(j,1); 
     diffy = Xt(i,2)  -  Y(j,2); 
     Xt(:,1) = Xt(:,1) - diffx;
     Xt(:,2) = Xt(:,2) - diffy;
     Xtt = 1000*ones(nsamp2, 2);
     Xtt(1:nsamp1,1:2) = Xt(:,1:2);

     Xt = Xtt;

     d1=sqrt(dist2(Xt, Y));

     if GC > 0   
       angle_diff = t_angle;
       sing1 = singular1;
       sing1(:,2) = singular1(:,2)*cos(r_t) - singular1(:,1)*sin(r_t);  
       sing1(:,1) = singular1(:,2)*sin(r_t) + singular1(:,1)*cos(r_t);  

       cdist = d1(ic1, ic2);

       if (GC==1)
          if cdist > 0.18 
             continue
          end
       else
          c_ratio=0;
       end
     end

     xt = min(Xt(1:nsamp1,2));
     xb = max(Xt(1:nsamp1,2));
     xl = min(Xt(1:nsamp1,1));
     xr = max(Xt(1:nsamp1,1));
     yt = min(Y(1:nsamp2,2));
     yb = max(Y(1:nsamp2,2));
     yl = min(Y(1:nsamp2,1));
     yr = max(Y(1:nsamp2,1));

     region_t=max(xt, yt);
     region_b=min(xb, yb);
     region_r=min(xr, yr);
     region_l=max(xl, yl);


     ind1=intersect(intersect(find(Xt(1:nsamp1,1) > region_l), find(Xt(1:nsamp1,1) < region_r)), intersect(find(Xt(1:nsamp1,2) > region_t), find(Xt(1:nsamp1,2) < region_b)) );
     ind2=intersect(intersect(find(Y(:,1) > region_l), find(Y(:,1) < region_r)), intersect(find(Y(:,2) > region_t), find(Y(:,2) < region_b))  );

     if numel(ind1) == 0 || numel(ind2) ==0
        continue
     end   

     nbins_theta=10; 
     nbins_r=5; %3 
     r_inner=0.01; 
     r_outer=min(region_b-region_t, region_r-region_l);  %1/2

     if xl < -0.2 || xr > 1.25 || (GC==3 && yt > f1.X(ic1,2)) || (GC==4 && xt < f2.X(ic2,2))
        continue
     end
if 1
     if r_outer >= 1/8
        r_outer=1;
        XX=Xt(ind1,:);
        XX(numel(ind1)+1,:)=[(xl+xr)/2, (xb+xt)/2];
        YY=Y(ind2,:);
        YY(numel(ind2)+1,:)=[(xl+xr)/2, (xb+xt)/2];
        out_vec_1=zeros(1,numel(ind1)+1); 
        out_vec_2=zeros(1,numel(ind2)+1);
%        out_vec_1=zeros(1,numel(ind1)); 
%        out_vec_2=zeros(1,numel(ind2));


        [BH1,mean_dist_1]=sc_compute(XX', zeros(1,numel(ind1)+1),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);
        [BH2,mean_dist_2]=sc_compute(YY',zeros(1,numel(ind2)+1),mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);

%        [BH1,mean_dist_1]=sc_compute(XX', zeros(1,numel(ind1)),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);
%        [BH2,mean_dist_2]=sc_compute(YY',zeros(1,numel(ind2)),mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);


        % compute pairwise cost between all shape contexts
        [costmat]=hist_cost_2(BH1,BH2,r_inner, r_outer, nbins_theta, nbins_r);

        sct=costmat(numel(ind1)+1, numel(ind2)+1);
        [a1,b1]=min(costmat,[],1);
        [a2,b2]=min(costmat,[],2);
        sct_p=mean(a1) + mean(a2);

        region_a = (region_b - region_t)*(region_r-region_l);

        if GC~=1 && sct_p > 0.9 || (sct/region_a > 4.5 && region_a > 0.11 || sct/region_a > 10.9) && GC==1
           continue
        end

     end
end
     for r=1:nsamp1
       m1t(r) = mod(m1t(r) - t_angle + pi, pi);
     end
     
     o_diff = [];
     index = 0;
     t_o=[];
     t_map=[]; 
     map1=[];
     map2=[];

     dists = [];
     for ii=1:size(Xt,1)
      [v,py] = min(d1(ii,:));
      for jj=1:size(Y,1)
          [v,px] = min(d1(:, jj));
          if d1(ii,jj) < 0.05 && m1(ii,3)<5 && m2(jj,3)<5
             if numel(find(map1==ii))==0
                map1(numel(map1)+1)=ii;
             end
             if numel(find(map2==jj))==0
                map2(numel(map2)+1)=jj;
             end
          end


          if px == ii && py == jj && Xtt(ii,1) < 1000 && d1(ii,jj) < 0.045 && m1(ii,3) < 5 && m2(jj,3) < 5 && abs(m1t(ii) - m2(jj,4)) < 0.5
             index = index + 1;
             o_diff(index) = abs(m1t(ii) - m2(jj,4));
             t_o(index) = orients(ii,jj)*max(m1(ii,6), m2(jj,6));
             t_map(index,:)=[ii,jj];
             dists(index)=d1(ii,jj);
          end
      end
     end


     o = sum(t_o)^2/index;
     c  = sum(t_o) - sum(o_res);

%     if GC==1 && cdist > 0.12  && ~((index > 5 || index > nsamp1/2) && mean(t_o) > 0.5) %index > 1
%        continue
%     end


     if VERBOSE
        cla
		subplot(2,2,1);
        Xtt(nsamp1+1:nsamp2, 1) = 0;
        Xtt(nsamp1+1:nsamp2, 2) = 0;
		subplot(2,2,1);
        plot(Xtt(:,1),Xtt(:,2),'b+',Y(:,1),Y(:,2),'ro')
        title(['i=' int2str(i) ' j=' int2str(j) ' n1=' int2str(nsamp1) ' n2=' int2str(nsamp2)])
        c
        GC
        index
        pause
     end

     if c > 0 && index>1 
%sct_p
%sct_p / exp(-region_a*2)
        m_map1=map1;
        m_map2=map2;
        sc=sct;
        area=region_a;
        o_res=t_o;
        map=t_map;
        cla
        test_n = index;
        angle = t_angle;
        Xtt(nsamp1+1:nsamp2, 1) = 0;
        Xtt(nsamp1+1:nsamp2, 2) = 0;
        Xo = Xtt;
        i1=ind1;
        i2=ind2;

hold on
        subplot(2,2,1);
        plot(Xtt(:,1),Xtt(:,2),'b+',Y(:,1),Y(:,2),'ro')
        if GC == 1
           plot(Xtt(ic1,1),Xtt(ic1,2),'g+',Y(ic2,1),Y(ic2,2),'go')
        end 
 title(['i=' int2str(i) ' j=' int2str(j) ' n1=' int2str(nsamp1) ' n2=' int2str(nsamp2)])
hold off
       drawnow
      end
   end
end

s1=numel(find(f1.M(:,3) < 5));
s2=numel(find(f2.M(:,3) < 5));

if numel(Xo) > 0 %&&  numel(i1) + numel(i2)-numel(o_res) < 10
   fr=f1;
   fr.M(:,4) = mod(fr.M(:,4) - angle + pi, pi);
   fr.X=Xo(1:nsamp1,:); 
   similarity=struct('map', map, 'o_res', o_res, 'sc', sc, 'area', area, 'angle', angle,'map1', m_map1, 'map2', m_map2 ); 
else
   911
   fr=f2;
   similarity=struct('map', [], 'o_res', [], 'sc', -1, 'area', -1 ); 
end


end
