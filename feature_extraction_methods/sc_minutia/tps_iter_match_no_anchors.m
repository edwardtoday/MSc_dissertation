%    Author: Joshua Abraham
%    Email: algorithm007@hotmail.com
%    Description: Performs a heavily modified iterative TPS warping based the freely available
%    Shape Context code by (paper found at http://www.eecs.berkeley.edu/Research/Projects/CS/vision/shape/pami.html)
%
%
%


function [sc_cost, Et, cvec, angle] = tps_iter_match_m1(m1, m2, X, Y, orients, nbins_theta, nbins_r, r_inner, r_outer, n_iter, r, beta_init, i1, i2, anchors)   

% script for doing shape-context based matching with alternating steps
% of estimating correspondences and estimating the regularized TPS
% transformation

if numel(anchors) > 0
  gcx=[anchors(:,1)' i1]
  gcy=[anchors(:,2)' i2]
  l_a=length(anchors(:,1)') 
else 
  gcx=[i1]
  gcy=[i2]
  l_a=0
end

angle=-1;

if numel(anchors) > 0
  mm1=m1(anchors(:,1)',:);
  mm2=m2(anchors(:,2)',:);
  x=X(anchors(:,1)',:);
  y=Y(anchors(:,2)',:);
else
  mm1=[];
  mm2=[];
  x=[];
  y=[];
end

m1=m1(gcx,:);
m2=m2(gcy,:);

ndum1=0; 
ndum2=0; 
eps_dum=1;
nsamp1=numel(gcx)
nsamp2=numel(gcy)
X=X(gcx,:);
Y=Y(gcy,:);

mean_dist_global=[]; 
display_flag = 0;
Et=0;

if nsamp2>nsamp1                                                                        
   % (as is the case in the outlier test)                                    
   ndum1=ndum1+(nsamp2-nsamp1);                                              
end                                                                                     
eps_dum=1; 

%JI: store minimum error in iterations to avoid 
% large jumps away from global minima to local minima
min_error = -1;


% initialize transformed version of model pointset
Xk=X;

% initialize counter
k=1;
s=1;
% out_vec_{1,2} are indicator vectors for keeping track of estimated
% outliers on each iteration
out_vec_1=zeros(1,nsamp1); 
out_vec_2=zeros(1,nsamp2);
cvec=[];

while s 
   %disp(['iter=' int2str(k)])

   % compute shape contexts for (transformed) model

%   [BH1,mean_dist_1]=sc_compute(Xk', m1(:,4)' ,mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);
   [BH1,mean_dist_1]=sc_compute(Xk', zeros(1,nsamp1) ,mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);

   % compute shape contexts for target, using the scale estimate from
   % the warped model
   % Note: this is necessary only because out_vec_2 can change on each
   % iteration, which affects the shape contexts.  Otherwise, Y does
   % not change.

%   [BH2,mean_dist_2]=sc_compute(Y',m2(:,4)',mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);
   [BH2,mean_dist_2]=sc_compute(Y',zeros(1,nsamp2),mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);

   % compute regularization parameter
   beta_k=(mean_dist_1^2)*beta_init*r^(k-1);

   % compute pairwise cost between all shape contexts
   costmat=hist_cost_2(BH1,BH2,r_inner, r_outer, nbins_theta, nbins_r);

   % ensure that no negative entries in the cost matrix
   temp = costmat < eps;
   costmat(temp) = eps;

   % pad the cost matrix with costs for dummies
   nptsd=nsamp1+ndum1;
   costmat2=eps_dum*ones(nptsd,nptsd);

   %JI: cost matrix with dummy nodes appended
   costmat2(1:nsamp1,1:nsamp2)=costmat;
   %disp('running hungarian alg.')

   costmat2=costmat2(l_a + 1 : nsamp2, l_a+1:nsamp2);

   dist_m=dist2(X(l_a + 1:nsamp1, :),Y(l_a + 1:nsamp2, :));
   for i=1:nsamp1-l_a
       for j=1:nsamp2-l_a 
           intersect_flag=0;   
           for li=1:l_a
               x1=X(li,1);
               x2=Y(li,1);
               x3=X(i,1);
               x4=Y(j,1);
               y1=X(li,2);
               y2=Y(li,2);
               y3=X(i,2);
               y4=Y(j,2);
   
               if det([1,1,1;x1,x2,x3;y1,y2,y3])*det([1,1,1;x1,x2,x4;y1,y2,y4]) <= 0 &&  det([1,1,1;x1,x3,x4;y1,y3,y4])*det([1,1,1;x2,x3,x4;y2,y3,y4]) <= 0
                  intersect_flag=1;   
               end
           end
           if intersect_flag
              costmat2(i,j)=costmat2(i,j)+100000;
              continue
           end

%           costmat2(i,j)=0.1*costmat2(i,j)+dist_m(i,j);%-max(orients(i,j),0.2);

           mox=m1(i,4);
           moy=m2(j,4);
           z=min(abs(mox-moy), abs(2*pi - abs(mox-moy))); 
           costmat2(i,j)=costmat2(i,j)*(dist_m(i,j)^2)*z;%/2;
%
%             if z < pi/8 && dist_m(i,j) < 0.06
%                    costmat2(i,j)=costmat2(i,j)*dist_m(i,j);%/2;
%                 else
%                    costmat2(i,j)=costmat2(i,j) + 5*abs(costmat2(i,j));
%             end

             if m1(i,4) == m2(j,4) 
    %             costmat2(i,j)=costmat2(i,j)*0.95;
             end
        end
   end

   if numel(costmat2) > 1
     cvec=hungarian(costmat2);
   else
     orient_res = -1;
     mse2 = 1;
     sc_cost = 1;
     E = 0;
     theta_offset_by_warping = 50;
     return
   end

   cvec=cvec+l_a;
   cvec=[1:l_a cvec];

   % update outlier indicator vectors
   [a,cvec2]=sort(cvec);
   out_vec_1=cvec2(1:nsamp1)>nsamp2;
   out_vec_2=cvec(1:nsamp2)>nsamp1;             %JI: cvec points to X match
     
   % format versions of Xk and Y that can be plotted with outliers'
   % correspondences missing

   X2=NaN*ones(nptsd,2);
   m1a = NaN*ones(nsamp2,6);
   X2(1:nsamp1,:)=Xk;
   m1a(1:nsamp1, :) = m1;
   X2=X2(cvec,:);
  
   m1a = m1a(cvec, :);
   X2b=NaN*ones(nptsd,2);
   X2b(1:nsamp1,:)=X;  
   X2b=X2b(cvec,:);
   m2a = m2;

   Y2=NaN*ones(nptsd,2); 
   Y2(1:nsamp2,:)=Y;

   % extract coordinates of non-dummy correspondences and use them
   % to estimate transformation
   ind_good=intersect(find(~isnan(X2b(:,1))), find(~isnan(Y2(:,1))));
   ind_good=intersect(find(~isnan(X2b(:,1))), find(~isnan(Y2(:,1))));

   dd=dist2(X2b(ind_good,:),Y2(ind_good,:)); 
   i_vgood=1:l_a ;%[];
   for i=l_a+1:min(numel(cvec), nsamp1)
       if dd(i,i) < 0.1
          i_vgood = [i_vgood i];
       end
   end
   ind_good = ind_good(i_vgood);   

   n_good=length(ind_good);

   X3b=X2b(ind_good,:);
   Y3=Y2(ind_good,:);

   m1a = m1a(ind_good,:);
   m2a = m2a(ind_good,:);

   n_good=length(ind_good);


   if display_flag == 0
      figure(2)
      plot(X2(:,1),X2(:,2),'b+',Y2(:,1),Y2(:,2),'ro')
      hold on
      h=plot([X2(:,1) Y2(:,1)]',[X2(:,2) Y2(:,2)]','k-');
      hold off
      title([int2str(n_good) ' correspondences (warped X)'])
      drawnow	
      % show the correspondences between the untransformed images
      figure(3)
      plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro')
      ind=cvec(ind_good);
      hold on
      plot([X2b(:,1) Y2(:,1)]',[X2b(:,2) Y2(:,2)]','k-')
      hold off
      title([int2str(n_good) ' correspondences (unwarped X)'])
      drawnow	
   end

   % estimate regularized TPS transformation
X3b
Y3
   if numel(X3b) > 1
      [cx,cy,E]=bookstein(X3b,Y3,beta_k);  
      if isnan(cx(1))
         mse2 = 1;
         sc_cost = 1;
%         Et = 50;
%         cvec=[];
break
%         return
      end
   else
     mse2 = 1;
     sc_cost = 1;
     E = 50;
     return
   end
   Et=Et+E;

   % calculate affine cost
   A=[cx(n_good+2:n_good+3,:) cy(n_good+2:n_good+3,:)];
   % JI: Compute the eigenvalues of A in an array, ordered descending.
   s=svd(A);                      
   aff_cost=log(s(1)/s(2))
   angle=abs(atan2( A(1,2) ,  A(2,2))*180/pi)

   orient_m = 0; 
   sc_cost = [];
   index = 0;
   m_index = 0;
   bad_count = 0;

   % warp each coordinate
   fx_aff=cx(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
   d2=max(dist2(X3b,X),0);
   U=d2.*log(d2+eps);
   fx_wrp=cx(1:n_good)'*U;
   fx=fx_aff+fx_wrp;
   fy_aff=cy(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
   fy_wrp=cy(1:n_good)'*U;
   fy=fy_aff+fy_wrp;

   Z=[fx; fy]';

   Zk=NaN*ones(nptsd,2);
   Zk(1:nsamp1,:)=Z;
   Zk=Zk(cvec,:);
   Zk = Zk(ind_good, :);

   % compute theta_offset_by_warping from Xk and Z, and update
   % theta_offset_total
   Diff = Xk - Z;
   diff_x = sum(Diff(:,1));
   diff_y = sum(Diff(:,2));

   % compute the mean squared error between synthetic warped image
   % and estimated warped image (using ground-truth correspondences
   % on TPS transformed image) 

 %  mse2=sqrt(mean((Y3(:,1)-Z(:,1)).^2+(Y3(:,2)-Z(:,2)).^2) );

  % mse2=sqrt(mean((Y3(:,1)-Zk(:,1)).^2+(Y3(:,2)-Zk(:,2)).^2) );
mse2=0;
%   disp(['error = ' num2str(mse2)])

   if display_flag == 0
      figure(4)
      plot(Z(:,1),Z(:,2),'b+',Y(:,1),Y(:,2),'ro');
      title(['recovered TPS transformation (k=' int2str(k) ', \lambda_o=' num2str(beta_init*r^(k-1)) ', I_f=' num2str(E) ', error=' num2str(mse2) ')']) 
      % show warped coordinate grid
      hold on
      plot(fx,fy,'k.','markersize',1)
      hold off
      drawnow
   end
   
   % update Xk for the next iteration
   Xk=Z;
   
   % stop early if shape context score is sufficiently low
   if k==n_iter || Et > 1000
      s=0;
   else
      k=k+1;
   end
end


%Y(cvec(l_a+1:nsamp1),:)
%Xk(cvec(l_a+1:nsamp1),:)
%X(cvec(l_a+1:nsamp1),:)

cvec=cvec(l_a+1:nsamp2);




%pause
map=[];
index=1;
if angle < 30 && Et < 13 %|| isnan(E)
%if angle < 15 && Et < 13 %|| isnan(E)
   for i=1:nsamp2-l_a
       if cvec(i) <= nsamp1 
           intersect_flag=0;   

%           d1=sqrt( (X(cvec(i),1)-Y(i,1))^2 + (X(cvec(i),2)-Y(i,2))^2);
           d1=sqrt( (Xk(cvec(i),1)-Y(i,1))^2 + (X(cvec(i),2)-Y(i,2))^2);

           for li=1:l_a
              x1=X(li,1);
              x2=Y(li,1);
              x3=X(cvec(i),1);
              x4=Y(i,1);
              y1=X(li,2);
              y2=Y(li,2);
              y3=X(cvec(i),2);
              y4=Y(i,2);
   
              if det([1,1,1;x1,x2,x3;y1,y2,y3])*det([1,1,1;x1,x2,x4;y1,y2,y4]) <= 0 &&  det([1,1,1;x1,x3,x4;y1,y3,y4])*det([1,1,1;x2,x3,x4;y2,y3,y4]) <= 0
                 intersect_flag=intersect_flag + 1   
              end
           end

           if d1 < 0.04 && intersect_flag<2 
              map(index,:)=[cvec(i)-l_a,i];
              index=index+1;
           else
                d1
           end
       end
   end
end
cvec=map;
angle

if Et > 13
   Et
%   pause
end
